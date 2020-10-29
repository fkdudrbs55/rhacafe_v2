import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import algoliasearch from 'algoliasearch';

// Set up Firestore.
admin.initializeApp();
const db = admin.firestore();

// Set up Algolia.
// The app id and API key are coming from the cloud functions environment, as we set up in Part 1, Step 3.
const algoliaClient = algoliasearch(functions.config().algolia.appid, functions.config().algolia.apikey);
// Since I'm using develop and production environments, I'm automatically defining 
// the index name according to which environment is running. functions.config().projectId is a default 
// property set by Cloud Functions.
// const collectionIndexName = functions.config().projectId === 'PRODUCTION-PROJECT-NAME' ? 'COLLECTION_prod' : 'COLLECTION_dev';

const collectionIndex = algoliaClient.initIndex('dev_rhacafe');

// Create a HTTP request cloud function.
export const sendCollectionToAlgolia = functions.https.onRequest(async (req, res) => {

	// This array will contain all records to be indexed in Algolia.
	// A record does not need to necessarily contain all properties of the Firestore document,
	// only the relevant ones. 
	const algoliaRecords : any[] = [];

	// Retrieve all documents from the COLLECTION collection.
	const querySnapshot = await db.collection('SampleCollection').get();

	querySnapshot.docs.forEach(doc => {
		const document = doc.data();
        // Essentially, you want your records to contain any information that facilitates search, 
        // display, filtering, or relevance. Otherwise, you can leave it out.
        const record = {
            objectID: doc.id,
            name: document['name'],
            subtitle: document['subtitle'],
			content: document['content'],
            location: document['location'],
            title: document['title'],
            contact: document['contact'],
            geopoint: document['geopoint'],
            imageUrl: document['imageUrl'],
            timestamp: document['timestamp']
        };

        algoliaRecords.push(record);
    });
	
	// After all records are created, we save them to 
    collectionIndex.saveObjects(algoliaRecords);
})


export const collectionOnCreate = functions.firestore.document('COLLECTION/{uid}').onCreate(async (snapshot, context) => {
    await saveDocumentInAlgolia(snapshot);
});

export const collectionOnUpdate = functions.firestore.document('COLLECTION/{uid}').onUpdate(async (change, context) => {
    await updateDocumentInAlgolia(change);
});

export const collectionOnDelete = functions.firestore.document('COLLECTION/{uid}').onDelete(async (snapshot, context) => {
    await deleteDocumentFromAlgolia(snapshot);
});

async function saveDocumentInAlgolia(snapshot: any) {
    if (snapshot.exists) {
        const record = snapshot.data();

        await collectionIndex.saveObject(record); // Adds or replaces a specific object.
    }
}

async function updateDocumentInAlgolia(change: functions.Change<FirebaseFirestore.DocumentSnapshot>) {
    const docBeforeChange = change.before
    const docAfterChange = change.after

    if (!docAfterChange.exists && docBeforeChange.exists) {
        await deleteDocumentFromAlgolia(docAfterChange);
    }else { 
        await saveDocumentInAlgolia(docAfterChange)
    }
}

async function deleteDocumentFromAlgolia(snapshot: FirebaseFirestore.DocumentSnapshot) {
    if (snapshot.exists) {
        const objectID = snapshot.id;
        await collectionIndex.deleteObject(objectID);
    }
}