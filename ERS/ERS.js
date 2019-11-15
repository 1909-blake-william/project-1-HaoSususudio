let currentUser;

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
      addReimbursementToTable(data);
      console.log(data);
    })
    .catch(err => console.log(err));
}

function addReimbursementToTable(reimbursement) {

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

  const managerButtonContainer = document.createElement('td');
  const approveButton = document.createElement('button');
  const denyButton = document.createElement('button');
  const whateverButton = document.createElement('button');

  approveButton.innerText = 'Approve';
  approveButton.className = 'btn btn-success';
  approveButton.onclick = function () { updateReimbStatus(row.id, 2) };

  denyButton.innerText = 'Deny';
  denyButton.className = 'btn btn-danger';
  denyButton.onclick = function () { updateReimbStatus(row.id, 3) };

  whateverButton.innerText = 'WHATEVER';
  whateverButton.className = 'btn btn-info';
  whateverButton.onclick = function () { updateReimbStatus(row.id, whateverStatusId()) };

  managerButtonContainer.appendChild(approveButton);
  managerButtonContainer.appendChild(denyButton);
  managerButtonContainer.appendChild(whateverButton);
  row.appendChild(managerButtonContainer);

  // append the row into the table
  document.getElementById('reimb-table-body').appendChild(row);
}

function getPokemonFromInputs() {
  const pokemonName = document.getElementById('pokemon-name-input').value;
  const pokemonHp = document.getElementById('pokemon-hp-input').value;
  const pokemonLevel = document.getElementById('pokemon-level-input').value;
  const pokemonType = document.getElementById('pokemon-type-select').value;

  const pokemon = {
    name: pokemonName,
    healthPoints: pokemonHp,
    level: pokemonLevel,
    type: {
      id: 5, // should probably find a way to get the correct id
      name: pokemonType
    },
    trainer: currentUser
  }
  return pokemon;
}



function getCurrentUserInfo() {
  fetch('http://localhost:8080/PokemonApi/auth/session-user', {
    credentials: 'include'
  })
    .then(resp => resp.json())
    .then(data => {
      document.getElementById('users-name').innerText = data.username
      fetchAndAppendAllReimb();
      currentUser = data;
    })
    .catch(err => {
      window.location = '/login/login.html';
    })
}

function fetchAndAppendAllReimb() {
  fetch('http://localhost:8080/DFNERSApi/api/reimbursements/')
    .then(res => res.json())
    .then(data => {
      data.forEach(addReimbursementToTable)
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

function refreshAllReimbs() {
  removeAllReimbs();
  fetchAndAppendAllReimb();
}

function removeAllReimbs() {
  document.querySelectorAll('tr.reimbursement')
    .forEach(ele => {
      ele.remove();
    })
}

function updateReimbStatus(reimbId, newStatusId) {
  console.log(reimbId, newStatusId);
}

function unixTimetoDateTime(unixTimestamp) {
  if (!unixTimestamp) {
    return null;
  }

  return Date(unixTimestamp * 1000);
}

fetchAndAppendAllReimb();

// getCurrentUserInfo();