let userDirectory;
let fullnameMap = new Map();
let currentUser;
let reimbData;

setupPage();

async function setupPage() {
  try {
    await makefullnameMap();
    await getCurrentUserInfo();
    if (currentUser.userRole === 'EMPLOYEE') {
      setupEmployeeMode();
    }
    else if (currentUser.userRole === 'MANAGER') {
      setupManagerMode();
    }
    else {
      alert('Account role undefined. Contact Admin');
      window.location.replace('/index.html');
    }
  } catch (error) {
    console.log('error');
    window.location.replace('/index.html');
  }
}

async function getUserDirectory() {
  try {
    const resp = await fetch('http://localhost:8080/DFNERSApi/api/users/', {
      credentials: 'include'
    });
    const data = await resp.json();
    userDirectory = data;
  }
  catch (err) {
    console.log('error');
  }
}

async function makefullnameMap() {
  try {
    await getUserDirectory();
    userDirectory.forEach(userInfo => {
      let fullname = userInfo.firstName + ' ' + userInfo.lastName;
      fullnameMap.set(userInfo.userId, fullname);
    })
  } catch (error) {
    console.log('error');
  }
}

async function getCurrentUserInfo() {
  try {
    const resp = await fetch('http://localhost:8080/DFNERSApi/auth/session-user', {
      credentials: 'include'
    });
    const data = await resp.json();
    currentUser = data;
  }
  catch (err) {
    console.log('error');
    window.location.replace('/index.html');
  }
}

function setupManagerMode() {
  document.getElementById('page-heading').innerText = 'Reimbursements - Manager Mode';

  let viewPendingBtn = document.createElement('button');
  viewPendingBtn.innerText = 'View Pending';
  viewPendingBtn.className = 'btn btn-primary btn-lg';
  viewPendingBtn.onclick = () => { managerRefreshReimb('pending') };
  document.getElementById('above-reimb-table').appendChild(viewPendingBtn);

  let viewApprovedBtn = document.createElement('button');
  viewApprovedBtn.innerText = 'View Approved';
  viewApprovedBtn.className = 'btn btn-success btn-lg';
  viewApprovedBtn.onclick = () => { managerRefreshReimb('approved') };
  document.getElementById('above-reimb-table').appendChild(viewApprovedBtn);

  let viewDeniedBtn = document.createElement('button');
  viewDeniedBtn.innerText = 'View Denied';
  viewDeniedBtn.className = 'btn btn-danger btn-lg';
  viewDeniedBtn.onclick = () => { managerRefreshReimb('denied') };
  document.getElementById('above-reimb-table').appendChild(viewDeniedBtn);

  let viewAllBtn = document.createElement('button');
  viewAllBtn.innerText = 'View all';
  viewAllBtn.className = 'btn btn-info btn-lg';
  viewAllBtn.onclick = () => { managerRefreshReimb('') };
  document.getElementById('above-reimb-table').appendChild(viewAllBtn);

  let whateverBtn = document.createElement('button');
  whateverBtn.innerText = 'WHATEVER';
  whateverBtn.id = 'whatever-btn';
  whateverBtn.className = 'btn btn-secondary btn-lg';
  whateverBtn.onclick = () => { whatever() };
  document.getElementById('above-reimb-table').appendChild(whateverBtn);

  managerRefreshReimb('pending');
}

function setupEmployeeMode() {
  let viewPendingBtn = document.createElement('button');
  viewPendingBtn.innerText = 'View Pending';
  viewPendingBtn.className = 'btn btn-primary btn-lg';
  viewPendingBtn.onclick = () => { employeeRefreshReimb('pending') };
  document.getElementById('above-reimb-table').appendChild(viewPendingBtn);

  let viewApprovedBtn = document.createElement('button');
  viewApprovedBtn.innerText = 'View Approved';
  viewApprovedBtn.className = 'btn btn-success btn-lg';
  viewApprovedBtn.onclick = () => { employeeRefreshReimb('approved') };
  document.getElementById('above-reimb-table').appendChild(viewApprovedBtn);

  let viewDeniedBtn = document.createElement('button');
  viewDeniedBtn.innerText = 'View Denied';
  viewDeniedBtn.className = 'btn btn-danger btn-lg';
  viewDeniedBtn.onclick = () => { employeeRefreshReimb('denied') };
  document.getElementById('above-reimb-table').appendChild(viewDeniedBtn);

  let viewAllbtn = document.createElement('button');
  viewAllbtn.innerText = 'View all';
  viewAllbtn.className = 'btn btn-info btn-lg';
  viewAllbtn.onclick = () => { employeeRefreshReimb('') };
  document.getElementById('above-reimb-table').appendChild(viewAllbtn);

  employeeRefreshReimb('pending');
  createNewReimbForm();
}

function createNewReimbForm() {
  if (document.getElementById('new-reimb-form')) {
    return;
  }

  const newReimbFormDiv = document.createElement('div');
  newReimbFormDiv.id = 'new-reimb-form-div';
  newReimbFormDiv.style.width = '50%';
  newReimbFormDiv.style.align = 'left';

  const newReimbForm = document.createElement('form');
  newReimbForm.id = 'new-reimb-form';
  newReimbForm.onsubmit = (event) => { submitNewReimb(event) };

  const typeLabel = document.createElement('label');
  typeLabel.for = 'new-reimb-type';
  typeLabel.innerText = 'Reimbursement Type';
  const type = document.createElement('select');
  type.className = 'form-control';
  type.id = 'new-reimb-type';
  type.required = 'true';
  const optDefault = document.createElement('option');
  optDefault.style = 'display:none';
  const optLodging = document.createElement('option');
  optLodging.innerText = 'Lodging';
  optLodging.value = 1;
  const optTravel = document.createElement('option');
  optTravel.innerText = 'Travel';
  optTravel.value = 2;
  const optFood = document.createElement('option');
  optFood.innerText = 'Food';
  optFood.value = 3;
  const optOther = document.createElement('option');
  optOther.innerText = 'Other';
  optOther.value = 4;

  const amountLabel = document.createElement('label');
  amountLabel.for = 'new-reimb-amount';
  amountLabel.innerText = 'Amount (round to cent):'
  const amount = document.createElement('input');
  amount.className = 'form-control';
  amount.id = 'new-reimb-amount';
  amount.required = 'true';
  amount.type = 'number';
  amount.step = '0.01';
  amount.min = '0';

  const descriptionLabel = document.createElement('label');
  descriptionLabel.for = 'new-reimb-description';
  descriptionLabel.innerText = 'Description';
  const description = document.createElement('textarea');
  description.className = 'form-control';
  description.id = 'new-reimb-description';
  description.rows = '3';
  description.required = 'true';

  const submitButton = document.createElement('button');
  submitButton.type = 'submit'
  submitButton.innerText = 'Submit';
  submitButton.className = 'btn btn-primary btn-lg';

  newReimbForm.appendChild(typeLabel);
  newReimbForm.appendChild(type);
  type.appendChild(optDefault);
  type.appendChild(optLodging);
  type.appendChild(optTravel);
  type.appendChild(optFood);
  type.appendChild(optOther);
  newReimbForm.appendChild(amountLabel);
  newReimbForm.appendChild(amount)
  newReimbForm.appendChild(descriptionLabel);
  newReimbForm.appendChild(description);
  newReimbForm.appendChild(submitButton);
  newReimbFormDiv.appendChild(newReimbForm);
  document.getElementById('page-bottom').appendChild(newReimbFormDiv);
}

async function submitNewReimb(event) {
  event.preventDefault();
  const newReimb = getReimbFromInputs();

  try {
    const resp = fetch('http://localhost:8080/DFNERSApi/api/reimbursements/', {
      method: 'POST',
      credentials: 'include',
      headers: {
        'content-type': 'application/json'
      },
      body: JSON.stringify(newReimb)
    })
      .then(resp => resp.json())
      .then(data => {
        document.getElementById('new-reimb-form').reset();
        employeeRefreshReimb('pending');
      })
  } catch (error) {
    console.log(err);
  }
}

function getReimbFromInputs() {
  const typeId = document.getElementById('new-reimb-type').value;
  const amount = document.getElementById('new-reimb-amount').value;
  const description = document.getElementById('new-reimb-description').value;
  const newReimb = {
    amount: parseFloat(amount),
    authorId: currentUser.userId,
    description: description,
    typeId: typeId
  }
  return newReimb;
}


async function managerRefreshReimb(status) {
  removeAllReimbs();
  await fetchReimb('', `${status}`);
  reimbData.forEach((reimb) => {
    let row = convertReimbToRow(reimb);
    addRowToReimbTable(row);
    appendManagerButtonsToRow(row, reimb.status);
  })
}

async function employeeRefreshReimb(status) {
  removeAllReimbs();
  await fetchReimb(`${currentUser.username}`, `${status}`);
  reimbData.forEach((reimb) => {
    let row = convertReimbToRow(reimb);
    addRowToReimbTable(row);
    appendEmpolyeeButtonsToRow(row, reimb.status);
  })
}

async function fetchReimb(author, status) {
  if (!author) {
    params = `?status=${status}`;
  } else {
    params = `?author=${author}&status=${status}`;
  }
  try {
    const resp = await fetch(`http://localhost:8080/DFNERSApi/api/reimbursements/${params}`, {
      credentials: 'include'
    });
    reimbData = await resp.json();
  }
  catch (err) {
    console.log('error');
  }
}

function removeAllReimbs() {
  document.querySelectorAll('tr.reimbursement')
    .forEach(ele => {
      ele.remove();
    })
}

async function updateReimbStatus(reimbId, statusId) {
  // event.preventDefault(); // stop page from refreshing
  const resolverId = currentUser.userId;
  let reimbUpdateReq = {
    reimbId: reimbId,
    statusId: statusId,
    resolverId: resolverId
  };
  fetch('http://localhost:8080/DFNERSApi/api/reimbursements/',
    {
      method: 'PUT',
      headers: {
        'content-type': 'application/json'
      },
      credentials: 'include', // put credentials: 'include' on every request to use session info
      body: JSON.stringify(reimbUpdateReq)
    })
    .then(res => res.json())
    .then(data => {
      let oldReimb = document.querySelector(`tr.reimbursement[id="${data.reimbId}"]`);
      let newReimb = convertReimbToRow(data);
      appendManagerButtonsToRow(newReimb, data.status);
      oldReimb.replaceWith(newReimb);
    })
    .catch(err => console.log(err))
}

function logout() {
  fetch('http://localhost:8080/DFNERSApi/auth/logout', {
    method: 'PUT',
    headers: {
      'content-type': 'application/json'
    },
    credentials: 'include', // put credentials: 'include' on every request to use session info
  }).then(() => {
    currentUser = null;
    window.location.replace('/index.html')
  })
}


async function whatever() {
  startWhateverSpinner();
  await fetchReimb('', 'pending');
  await reimbData.forEach((reimb) => {
    batchUpdateReimbStatus(parseInt(reimb.reimbId), whateverStatusId());
  });
  await managerRefreshReimb('pending');
  stopWhateverSpinner();
}

async function batchUpdateReimbStatus(reimbId, statusId) {
  // event.preventDefault(); // stop page from refreshing
  const resolverId = currentUser.userId;
  let reimbUpdateReq = {
    reimbId: reimbId,
    statusId: statusId,
    resolverId: resolverId
  };
  fetch('http://localhost:8080/DFNERSApi/api/reimbursements/',
    {
      method: 'PUT',
      headers: {
        'content-type': 'application/json'
      },
      credentials: 'include', // put credentials: 'include' on every request to use session info
      body: JSON.stringify(reimbUpdateReq)
    })
    .catch(err => console.log(err))
}

function whateverStatusId() {
  let rnd = Math.random();
  if (rnd <= 0.7) {
    return 2;
  } else if (0.7 < rnd) {
    return 3;
  }
}

function startWhateverSpinner() {
  whateverbtn = document.getElementById('whatever-btn');
  whateverbtn.disabled = 'true';
  whateverbtn.innerHTML =
    ` <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span><span class="sr-only">WHATEVER...</span>`;
}

function stopWhateverSpinner() {
  whateverbtn = document.getElementById('whatever-btn');
  // document.getElementById('whatever-btn').removeattribute('disabled');
  whateverbtn.removeAttribute('disabled');
  whateverbtn.innerHTML = 'WHATEVER';
}


function unixTimetoDateTime(unixTimestamp) {
  if (!unixTimestamp) {
    return null;
  }
  let date = new Date(unixTimestamp);

  return date.toDateString() + ' ' + date.toLocaleTimeString();
}

function convertReimbToRow(reimbursement) {
  // create the row element
  const row = document.createElement('tr');
  row.id = `${reimbursement.reimbId}`;
  row.className = 'reimbursement';

  // create all the td elements and append them to the row
  const reimbId = document.createElement('td');
  reimbId.innerText = reimbursement.reimbId;
  row.appendChild(reimbId);

  const amount = document.createElement('td');
  amount.innerText = reimbursement.amount;
  row.appendChild(amount);

  const submittedTime = document.createElement('td');
  submittedTime.innerText = unixTimetoDateTime(reimbursement.submittedTime);
  row.appendChild(submittedTime);

  const resolvedTime = document.createElement('td');
  resolvedTime.innerText = unixTimetoDateTime(reimbursement.resolvedTime);
  resolvedTime.id = 'resolved-time';
  row.appendChild(resolvedTime);

  const description = document.createElement('td');
  description.innerText = reimbursement.description;
  row.appendChild(description);

  const author = document.createElement('td');
  author.innerText = fullnameMap.get(reimbursement.authorId);
  row.appendChild(author);

  const resolver = document.createElement('td');
  resolver.innerText = fullnameMap.get(reimbursement.resolverId) || '';
  resolver.id = 'resolverId';
  row.appendChild(resolver);

  const status = document.createElement('td');
  status.innerText = reimbursement.status;
  status.id = 'status';
  row.appendChild(status);

  const type = document.createElement('td');
  type.innerText = reimbursement.type;
  row.appendChild(type);

  return row;
}

function appendManagerButtonsToRow(row, status) {
  let managerButtonContainer = document.createElement('td');
  let approveButton = document.createElement('button');
  let denyButton = document.createElement('button');

  approveButton.innerText = 'Approve';
  approveButton.className = 'btn btn-success';
  denyButton.innerText = 'Deny';
  denyButton.className = 'btn btn-danger';

  if ('PENDING' === status) {
    approveButton.onclick = () => { updateReimbStatus(parseInt(row.id), 2) };
    denyButton.onclick = () => { updateReimbStatus(parseInt(row.id), 3) };

  } else {
    approveButton.setAttribute('disabled', '');
    denyButton.setAttribute('disabled', '');
    // approveButton.onclick = () => { updateReimbStatus(parseInt(row.id), 2) };
    // denyButton.onclick = () => { updateReimbStatus(parseInt(row.id), 3) };
  }

  managerButtonContainer.appendChild(approveButton);
  managerButtonContainer.appendChild(denyButton);
  row.insertAdjacentElement('beforeend', managerButtonContainer);
}

function appendEmpolyeeButtonsToRow(row, status) {
  let actionContainer = document.createElement('td');
  let actionBtn = document.createElement('button');

  if ('PENDING' === status) {
    actionBtn.innerText = 'Raise Attention';
    actionBtn.className = 'btn btn-primary';
  } else if ('APPROVED' === status) {
    actionBtn.innerText = 'Cash in $$$';
    actionBtn.className = 'btn btn-success';
  } else if ('DENIED' === status) {
    actionBtn.innerText = 'Dispute';
    actionBtn.className = 'btn btn-secondary';
  }
  actionContainer.appendChild(actionBtn);
  row.insertAdjacentElement('beforeend', actionContainer);
}

function addRowToReimbTable(row) {
  document.getElementById('reimb-table-body').appendChild(row);
}