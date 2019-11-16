let currentUser;
getCurrentUserInfo();

function getCurrentUserInfo() {
  fetch('http://localhost:8080/DFNERSApi/auth/session-user', {
    credentials: 'include'
  })
    .then(resp => resp.json())
    .then(data => {
      currentUser = data;
      if (currentUser.userRole === 'EMPLOYEE') {
        console.log(currentUser.userRole);
        setupEmployeeMode();

      } else if (currentUser.userRole === 'MANAGER') {
        console.log(currentUser);
        setupManagerMode();
      } else {
        // alert('Account role undefined. Contact Admin');
        // window.location.assign('/index.html');
      }
    })
    .catch(err => {
      // console.log('error');
      // window.location.assign('/index.html');
    })
}

function setupManagerMode() {
  document.getElementById('page-heading').innerText = 'Reimbursements - Manager Mode';
  let actionsTh = document.createElement('th');
  actionsTh.scope = 'col';
  actionsTh.innerText = 'Actions';
  document.getElementById('reimb-header-row').appendChild(actionsTh);

  managerFetchAppendAll();


  let refreshButton = document.createElement('button');
  refreshButton.innerText = 'Refresh All';
  refreshButton.className = 'btn btn-primary btn-lg';
  refreshButton.onclick = refreshAllReimbs;
  document.getElementById('page-bottom').appendChild(refreshButton);
}

function setupEmployeeMode() {
  employeeFetchAppendAll();
}

function employeeFetchAppendAll() {
  let author = currentUser.username;
  console.log(author);
  fetch(`http://localhost:8080/DFNERSApi/api/reimbursements/?author=${author}`)
    .then(res => res.json())
    .then(data => {
      data.forEach(addReimbToTable)
    })
    .catch(console.log);
}

function managerFetchAppendAll(callback) {
  fetch('http://localhost:8080/DFNERSApi/api/reimbursements/')
    .then(res => res.json())
    .then(data => {
      data.forEach(addReimbToTable);
    })
    .catch(console.log);
  callback();
}

function newPokemonSubmit(event) {
  event.preventDefault(); // stop page from refreshing
  console.log('submitted');

  const pokemon = getPokemonFromInputs();

  fetch('http://localhost:8080/PokemonApi/pokemon', {
    method: 'POST',
    body: JSON.stringify(pokemon),
    headers: {
      'content-type': 'application/json'
    }
  })
    .then(res => res.json())
    .then(data => {
      managerAddReimb(data);
      console.log(data);
    })
    .catch(err => console.log(err));
}


function addReimbManagerButtons() {

  reimbRows = document.querySelectorAll('tbody#reimb-table-body>tr');
  reimbRows.forEach((row) => {
    let managerButtonContainer = document.createElement('td');
    let approveButton = document.createElement('button');
    let denyButton = document.createElement('button');

    approveButton.innerText = 'Approve';
    approveButton.className = 'btn btn-success';
    approveButton.onclick = function () { updateReimbStatus(parseInt(row.id), 2) };
    denyButton.innerText = 'Deny';
    denyButton.className = 'btn btn-danger';
    denyButton.onclick = function () { updateReimbStatus(parseInt(row.id), 3) };

    managerButtonContainer.appendChild(approveButton);
    managerButtonContainer.appendChild(denyButton);
    row.appendChild(managerButtonContainer);
  })

}


function refreshAllReimbs() {
  removeAllReimbs();
  managerFetchAppendAll();
}

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
  fetch('http://localhost:8080/DFNERSApi/api/reimbursements/', {
    method: 'PUT',
    headers: {
      'content-type': 'application/json'
    },
    credentials: 'include', // put credentials: 'include' on every request to use session info
    body: JSON.stringify(reimbUpdateReq)
  })
    .then(res => res.json())
    .then(data => {
      console.log(data);
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
  return Date(unixTimestamp * 1000);
}

function addReimbToTable(reimbursement) {
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
  row.appendChild(resolvedTime);

  const description = document.createElement('td');
  description.innerText = reimbursement.description;
  row.appendChild(description);

  const authorId = document.createElement('td');
  authorId.innerText = reimbursement.authorId;
  row.appendChild(authorId);

  const resolverId = document.createElement('td');
  resolverId.innerText = reimbursement.resolverId;
  row.appendChild(resolverId);

  const status = document.createElement('td');
  status.innerText = reimbursement.status;
  row.appendChild(status);

  const type = document.createElement('td');
  type.innerText = reimbursement.type;
  row.appendChild(type);

  // append the row into the table
  document.getElementById('reimb-table-body').appendChild(row);
}
