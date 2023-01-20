const functions = require("firebase-functions");
const admin = require("firebase-admin");
// to get the ADC automatically
admin.initializeApp({ credential: admin.credential.applicationDefault() }); 

exports.sendNewPostNotification = functions.database.ref('/posts/{postId}').onCreate(event=>{
    //const postId = event.params.postId;

    //console.log('Postid: ', postId);

    //const creationId = event.params.postId;

    const topic = 'newPosts';

	const message = {
	  notification: {
	    title: 'neuer Post',
	    body: 'Jemand hat einen neuen Post hochgeladen'
	  },
	  topic: topic
	};

	// Send a message to devices subscribed to the provided topic.
	admin.messaging().send(message)
	  .then((response) => {
	    // Response is a message ID string.
	    console.log('Successfully sent message:', response);
	  })
	  .catch((error) => {
	    console.log('Error sending message:', error);
	  });
});

exports.addNumbers = functions.https.onCall((data) => {
// [END addFunctionTrigger]
  // [START readAddData]
  // Numbers passed from the client.
  const firstNumber = data.firstNumber;
  const secondNumber = data.secondNumber;
  // [END readAddData]

  // [START addHttpsError]
  // Checking that attributes are present and are numbers.
  if (!Number.isFinite(firstNumber) || !Number.isFinite(secondNumber)) {
    // Throwing an HttpsError so that the client gets the error details.
    throw new functions.https.HttpsError('invalid-argument', 'The function must be called with ' +
        'two arguments "firstNumber" and "secondNumber" which must both be numbers.');
  }
  // [END addHttpsError]

  // [START returnAddData]
  // returning result.
  return {
    firstNumber: firstNumber,
    secondNumber: secondNumber,
    operator: '+',
    operationResult: firstNumber + secondNumber,
  };
  // [END returnAddData]


});