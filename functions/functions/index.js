const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);



exports.messageTrigger = functions.firestore.document("pendingRequests/{messageId}").onCreate(async (snapshot, context) => {
    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }

    var newData;

    var tokens = [];

    newData = snapshot.data();
    if (newData.permission_by.length === 0) {
        console.log("no token available");
        return;
    }

    for (let i = 0; i < newData.permission_by.length; i++) {
        tokens.push(newData.permission_by[i]['token']);
    }
    var title;
    var message;
    if (newData.collectionName === "vehicleEntries") {
        title = "New Vehicle Entry Created";
        message = "Please Accept or Decline";
    } else {
        title = "New Goods Approval Entry"
        message = "Please Accept or Decline";
    }



    var payload = {
        notification: { title: title, body: message, sound: 'default' },
        data: { click_action: "FLUTTER_NOTIFICATION_CLICK", message: newData.collectionName },
    };
    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log("Notification sent Successfully");
    } catch (err) {
        console.log("Notification failed ");
    }
});

exports.statusChangeTrigger = functions.firestore.document("goodsApproval/{messageId}").onUpdate(async (snapshot, context) => {
    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }


    var newData;
    var prevData;
    var tokens = [];



    prevData = snapshot.before.data();
    newData = snapshot.after.data();

    if (newData.status === "Pending" || prevData.status !== "Pending") {
        return;
    }

    const userData = await admin.firestore().collection('userData').doc(newData.created_by['id']).get();

    tokens.push(userData.data().token);


    var payload = {
        notification: { title: "Goods Approval Status Updated", body: newData.status, sound: 'default' },
        data: { click_action: "FLUTTER_NOTIFICATION_CLICK", message: "goods" },
    };
    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log("Notification sent Successfully");
    } catch (err) {
        console.log("Notification failed ");
        console.log(err);
    }
});

exports.vehicleEntryStatusChangeTrigger = functions.firestore.document("vehicleEntries/{messageId}").onUpdate(async (snapshot, context) => {
    if (snapshot.empty) {
        console.log('No Devices');
        return;
    }



    var newData;
    var prevData;
    var tokens = [];



    prevData = snapshot.before.data();
    newData = snapshot.after.data();

    if (newData.status === "Pending" || prevData.status !== "Pending") {
        return;
    }

    const userData = await admin.firestore().collection('userData').doc(newData.created_by['id']).get();


    tokens.push(userData.data().token);


    var payload = {
        notification: { title: "Vehicle Entry Status Updated ", body: newData.status, sound: 'default' },
        data: { click_action: "FLUTTER_NOTIFICATION_CLICK", message: "vehicle" },
    };
    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log("Notification sent Successfully");
    } catch (err) {
        console.log("Notification failed ");
        console.log(err);
    }
});




// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
