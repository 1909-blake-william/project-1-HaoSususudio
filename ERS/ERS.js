let userDirectory;
let fullnameMap = new Map();
let currentUser;
let reimbData;
setupPage();

async function setupPage() {
  try {
    await makefullnameMap();
    await getCurrentUserInfo();
    console.log(currentUser);
    if (currentUser.userRole === 'EMPLOYEE') {
      setupEmployeeMode();
    }
    else if (currentUser.userRole === 'MANAGER') {
      setupManagerMode();
    }
    else {
      alert('Account role undefined. Contact Admin');
      window.location.assign('/index.html');
    }
  } catch (error) {
    console.log('error');
    window.location.assign('/index.html');
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
    window.location.assign('/index.html');
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

  let viewAllbtn = document.createElement('button');
  viewAllbtn.innerText = 'View all';
  viewAllbtn.className = 'btn btn-info btn-lg';
  viewAllbtn.onclick = () => { managerRefreshReimb('') };
  document.getElementById('above-reimb-table').appendChild(viewAllbtn);

  managerRefreshReimb('pending');
}

async function setupEmployeeMode() {
  addRowToReimbTable(createReimbInputFields());
  employeeFetchAppendReimb();
}

function createReimbInputFields() {
  // create the row element
  const row = document.createElement('tr');
  row.id = 'new-reimb-input';

  // create all the td elements and append them to the row
  const reimbId = document.createElement('td');
  reimbId.innerText = 'New'
  row.appendChild(reimbId);

  const amount = document.createElement('td');
  row.appendChild(amount);

  const submittedTime = document.createElement('td');
  // submittedTime.innerText = unixTimetoDateTime(reimbursement.submittedTime);
  row.appendChild(submittedTime);

  const resolvedTime = document.createElement('td');
  // resolvedTime.innerText = unixTimetoDateTime(reimbursement.resolvedTime);
  // resolvedTime.id = 'resolved-time';
  row.appendChild(resolvedTime);

  const description = document.createElement('td');
  row.appendChild(description);

  const author = document.createElement('td');
  author.innerText = fullnameMap.get(currentUser.userId);
  row.appendChild(author);

  const resolver = document.createElement('td');
  row.appendChild(resolver);

  const status = document.createElement('td');
  row.appendChild(status);

  const type = document.createElement('td');
  row.appendChild(type);

  return row;
}

// function refreshReimbs(author, status) {
//   removeAllReimbs();
//   // if (currentUser.userRole = 'MANAGER') {
//   managerRefreshReimb(status);
//   // } else if (currentUser.userRole = 'EMPLOYEE') {
//   // employeeFetchAppendReimb(status);
//   // }
// }

async function managerRefreshReimb(status) {
  removeAllReimbs();
  await fetchReimb('', `${status}`);
  reimbData.forEach((reimb) => {
    let row = convertReimbToRow(reimb);
    addRowToReimbTable(row);
    appendManagerButtonsToRow(row, reimb.status);
  })
}

async function employeeFetchAppendReimb(status) {
  await fetchReimb(`${currentUser.username}`, `${status}`);
  // console.log(author);
  reimbData.forEach((reimb) => {
    let row = convertReimbToRow(reimb);
    addRowToReimbTable(row);
  })
}

async function fetchReimb(author, status) {
  if (!author) {
    params = `?status=${status}`;
  } else {
    params = `?author=${author}&?status=${status}`;
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


// fetch(`http://localhost:8080/DFNERSApi/api/reimbursements/?author=${author}`)
//   .then(res => res.json())
//   .then(data => {
//     data.forEach((reimb) => {
//       let row = convertReimbToRow(reimb);
//       addRowToReimbTable(row);

//     })
//   })
//   .catch(console.log);
// }

// function newPokemonSubmit(event) {
//   event.preventDefault(); // stop page from refreshing
//   console.log('submitted');

//   const pokemon = getPokemonFromInputs();

//   fetch('http://localhost:8080/PokemonApi/pokemon', {
//     method: 'POST',
//     body: JSON.stringify(pokemon),
//     headers: {
//       'content-type': 'application/json'
//     }
//   })
//     .then(res => res.json())
//     .then(data => {
//       managerAddReimb(data);
//       console.log(data);
//     })
//     .catch(err => console.log(err));
// }


function removeAllReimbs() {
  document.querySelectorAll('tr.reimbursement')
    .forEach(ele => {
      ele.remove();
    })
}

function updateReimbStatus(reimbId, statusId) {
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
    .catch(console.log);
}

function whateverStatusId() {
  let rnd = Math.random();
  if (rnd <= 0.1) {
    return 1;
  } else if (0.1 < rnd && rnd <= 0.7) {
    return 2;
  } else if (0.7 < rnd) {
    return 3;
  }
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
    // approveButton.setAttribute('disabled', '');
    // denyButton.setAttribute('disabled', '');
    approveButton.onclick = () => { updateReimbStatus(parseInt(row.id), 2) };
    denyButton.onclick = () => { updateReimbStatus(parseInt(row.id), 3) };
  }

  managerButtonContainer.appendChild(approveButton);
  managerButtonContainer.appendChild(denyButton);
  row.insertAdjacentElement('beforeend', managerButtonContainer);
}


function addRowToReimbTable(row) {
  document.getElementById('reimb-table-body').appendChild(row);
}