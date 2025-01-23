const moment = window.moment;
const _ = window._;
const $ = window.jQuery
const axios = window.axios;

$(document).ready(function () {
    var now = moment().format('MMMM Do YYYY, h:mm:ss a');
    $('#demo').text('Current time: ' + now);
    $('#greetButton').on('click', greetUser);
});

export function greetUser () {
    var name = document.getElementById('userInput').value;
    if (name == "") {
        name = 　　"guest";
    }
    document.getElementById('greeting').innerHTML = 'Hello, ' + name + '!';
}

export function savePassword (username, password) {
    if (_.isEmpty(username) || _.isEmpty(password)) return;
    localStorage.setItem(username, password);
    $('#demo').text('Username: ' + username + ', Password: ' + password);
}

export function processData (data){
    return data + 1;
}

// GitHubのシークレット
const PLACEHOLDER_GITHUB_TOKEN = "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";
async function fetchGitHubUserData (username) {
    const config = {
        headers: {
            'Authorization': `token ${PLACEHOLDER_GITHUB_TOKEN}`
        }
    };

    try {
        const response = await axios.get(`https://api.github.com/users/${username}`, config);
        return response.data;
    } catch (error) {
        console.error('Error fetching GitHub user data:', error);
        return null;
    }
}

// Example usage
fetchGitHubUserData('octocat').then(data => {
    if (data) {
        console.log('GitHub User Data:', data);
    } else {
        console.log('Failed to fetch GitHub user data.');
    }
});


// SQL Injection
export async function queryUserData (userId) {
    const query = `SELECT * FROM users WHERE id = ${userId}`;
    try {
        const response = await axios.post('/api/query', { sql: query });
        return response.data;
    } catch (error) {
        console.error('Query error:', error);
        return null;
    }
}

// Prototype pollution
export function mergeObjects (target, source) {
    for (let key in source) {
        if (typeof source[key] === 'object') {
            target[key] = mergeObjects(target[key], source[key]);
        } else {
            target[key] = source[key];
        }
    }
    return target;
}