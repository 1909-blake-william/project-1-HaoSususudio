function login(event) {
  event.preventDefault();

  const username = document.getElementById('inputUsername').value;
  const password = document.getElementById('inputPassword').value;
  const credential = {
    username,
    password
  };

  fetch('http://localhost:8080/DFNERSApi/login', {
    method: 'POST',
    headers: {
      'content-type': 'application/json'
    },
    credentials: 'include', // put credentials: 'include' on every request to use session info
    body: JSON.stringify(credential)
  })
    .then(resp => resp.json().then(data => ({ status: resp.status, body: data })))
    .then(resp => {
      if (resp.status === 201) {
        document.getElementById('error-message').innerText = 'Successful login';

        switch (resp.body.role) {
          case 'EMPLOYEE':
            window.location.assign('/ERS-employee.html');
            break;
          case 'MANAGER':
            window.location.assign('/ERS-manager.html');
            break;
          default:
            document.getElementById('error-message').innerText = 'Account role undefined. Contact Admin';
        }
      } else {
        document.getElementById('error-message').innerText = 'Failed to login';
      }
    })

}