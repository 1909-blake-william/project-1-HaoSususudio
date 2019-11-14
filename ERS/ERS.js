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

  // create all the td elements and append them to the row
  const reimbId = document.createElement('td');
  reimbId.innerText = reimbursement.reimbId;
  row.appendChild(reimbId);

  const amount = document.createElement('td');
  amount.innerText = reimbursement.amount;
  row.appendChild(amount);

  const submittedTime = document.createElement('td');
  submittedTime.innerText = reimbursement.submittedTime;
  row.appendChild(submittedTime);

  const resolvedTime = document.createElement('td');
  resolvedTime.innerText = reimbursement.resolvedTime;
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

function addPokemonToTable(pokemon) {
  document.getElementById('reimb-table-body').innerHTML += `
    <tr>
        <td>${pokemon.name}</td>
        <td>${pokemon.type.name}</td>
        <td>${pokemon.healthPoints}</td>
        <td>${pokemon.level}</td>
        <td>${pokemon.trainer.username}</td>
    </tr>
    `;
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

function refreshTable() {
  fetch('http://localhost:8080/DFNERSApi/api/reimbursements/')
    .then(res => res.json())
    .then(data => {
      console.log(data)
      data.forEach(addReimbursementToTable)
    })
    .catch(console.log);
}


function getCurrentUserInfo() {
  fetch('http://localhost:8080/PokemonApi/auth/session-user', {
    credentials: 'include'
  })
    .then(resp => resp.json())
    .then(data => {
      document.getElementById('users-name').innerText = data.username
      refreshTable();
      currentUser = data;
    })
    .catch(err => {
      window.location = '/login/login.html';
    })
}
refreshTable()

// getCurrentUserInfo();