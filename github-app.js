const { App } = require("@octokit/app");
const { request } = require("@octokit/request");

const app = new App({
  appId: process.env.GITHUB_APP_ID,
  privateKey: process.env.GITHUB_PRIVATE_KEY,
  oauth: {
    clientId: process.env.GITHUB_CLIENT_ID,
    clientSecret: process.env.GITHUB_CLIENT_SECRET,
  },
});

async function run() {
  const jwt = app.getSignedJsonWebToken();
  
  const { data } = await request('GET /app', {
    headers: {
      authorization: `Bearer ${jwt}`,
      accept: 'application/vnd.github.v3+json'
    }
  });
  
  console.log(data);
}

run();