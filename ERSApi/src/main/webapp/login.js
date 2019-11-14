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
        .then(resp => {
            if (resp.status === 201) {
                console.log(resp.body);
                // redirect
                document.getElementById('error-message').innerText = 'Successful login';
                console.log('navigate to ERS app')
                // window.location.assign() = '/client/ERS-employee.html';
            } else {
                document.getElementById('error-message').innerText = 'Failed to login';
            }
        })


}