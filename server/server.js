
var SquareConnect = require('square-connect');
var defaultClient = SquareConnect.ApiClient.instance;
var app = require('express')();
var bodyParser = require('body-parser');
var bodyParser = require('body-parser')
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));
app.get("/", (request, response) => {
  if (request.query.nonce == null) {
    response.send({
      code: 400,
      message: "nonce not found"
    })
  }
  var oauth2 = defaultClient.authentications['oauth2'];
  oauth2.accessToken = 'EAAAEBUL2BOH8jy1GrRu5CARla09jywI3lAPkiRF97AYgHG1JAkBjFMfEq8oX4V3';
  var transactionApi = new SquareConnect.TransactionsApi();
  transactionApi.charge("HZY7YWQCR2XTZ", {
    idempotency_key: new Date(),
    card_nonce: request.query.nonce,
    amount_money: {
      amount: 500,
      currency: "PKR"
    }
  }).then(function (data) {
    console.log('API called successfully. Returned data: ' + JSON.stringify(data));
    response.send(data);
  }, function (error) {
    console.error(JSON.parse(error.response.text).errors[0].detail);
    response.send(error);
  });
})

app.set('port', process.env.PORT || 4000);
app.listen(app.get('port'), function () {
  console.log(`Express Started on: http://localhost:${app.get('port')}`);
});

// app.listen('http://10.0.75.1:8080', () => {
//     console.log("Server running...");
// })