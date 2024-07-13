const express = require('express')
const app = express();
const hostname = "localhost";
const PORT = 3000;

app.get("/", (req, res) => {
  res.send("Hello from Express!\n");
});

app.listen(PORT, () => {
  console.log(`Express server running at http://${hostname}:${PORT}/`);
});
