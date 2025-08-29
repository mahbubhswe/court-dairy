import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

/// Add or update a document in a Firestore collection.
/// [collectionName] is the name of the Firestore collection.
/// [data] is the data to set in the document.
/// [documentId] is the optional document ID. If not provided, Firestore will generate one.
/// Returns true if the operation is successful, otherwise false.
Future<bool> setDocument({
  required String collectionName,
  required Map<String, dynamic> data,
  required String documentId,
}) async {
  try {
    final collectionRef = firestore.collection(collectionName);

    // If a document ID is provided, set the document with that ID.
    await collectionRef.doc(documentId).set(data);
    return true; // Operation was successful
  } catch (error) {
    return false; // Operation failed
  }
}

/// Add a document to a Firestore collection.
/// [collectionName] is the name of the Firestore collection.
/// [data] is the data to add.
Future<Map<String, dynamic>> addDocument({
  required String collectionName,
  required Map<String, dynamic> data,
}) async {
  try {
    final collectionRef = firestore.collection(collectionName);

    // Add the new document to Firestore
    final docRef = await collectionRef.add(data);

    return {'id': docRef.id};
  } catch (error) {
    return {'error': error.toString()};
  }
}

/// Get all documents from a Firestore collection as a stream.
Stream<Map<String, dynamic>> getDocumentsStream(
    {required String collectionName}) {
  try {
    return firestore
        .collection(collectionName)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return {
          'documents': []
        }; // Return empty array if no documents are found
      }

      final documents = querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      return {'documents': documents};
    });
  } catch (error) {
    return Stream.value({'error': error.toString()});
  }
}

/// Get a single document by ID from a Firestore collection.
/// [collectionName] is the name of the Firestore collection.
/// [id] is the ID of the document.
Future<Map<String, dynamic>> getDocumentById({
  required String collectionName,
  required String id,
}) async {
  try {
    final docSnapshot =
        await firestore.collection(collectionName).doc(id).get();

    if (!docSnapshot.exists) {
      return {'error': 'Document not found'};
    }

    return {
      'id': docSnapshot.id,
      ...docSnapshot.data() as Map<String, dynamic>
    };
  } catch (error) {
    return {'error': error.toString()};
  }
}

/// Get a stream of a single document by ID from a Firestore collection.
/// [collectionName] is the name of the Firestore collection.
/// [id] is the ID of the document.
Stream<Map<String, dynamic>> getDocumentStreemById({
  required String collectionName,
  required String id,
}) {
  return firestore
      .collection(collectionName)
      .doc(id)
      .snapshots()
      .map((docSnapshot) {
    if (!docSnapshot.exists) {
      return {'error': 'Document not found'};
    }

    return {
      'id': docSnapshot.id,
      ...docSnapshot.data() as Map<String, dynamic>
    };
  }).handleError((error) {
    return {'error': error.toString()};
  });
}

/// Update a document in a Firestore collection by ID.
/// [collectionName] is the name of the Firestore collection.
/// [id] is the ID of the document.
/// [data] is the updated data.
Future<Map<String, dynamic>> updateDocument({
  required String collectionName,
  required String id,
  required Map<String, dynamic> data,
}) async {
  try {
    final docRef = firestore.collection(collectionName).doc(id);
    await docRef.update(data);

    return {'success': true};
  } catch (error) {
    return {'error': error.toString()};
  }
}

/// Update an array field in a Firestore document.
/// [collectionName] is the name of the Firestore collection.
/// [id] is the ID of the document.
/// [field] is the array field to update.
/// [value] is the value to add or remove from the array.
/// [isAdd] indicates whether to add or remove the value.
Future<Map<String, dynamic>> updateArrayField({
  required String collectionName,
  required String id,
  required String field,
  required dynamic value,
  required bool isAdd, // true to add, false to remove
}) async {
  try {
    final docRef = firestore.collection(collectionName).doc(id);

    // Use arrayUnion to add an element to the array, or arrayRemove to remove it
    if (isAdd) {
      await docRef.update({
        field: FieldValue.arrayUnion([value])
      });
    } else {
      await docRef.update({
        field: FieldValue.arrayRemove([value])
      });
    }

    return {'success': true};
  } catch (error) {
    return {'error': error.toString()};
  }
}

/// Delete a document from a Firestore collection by ID.
/// [collectionName] is the name of the Firestore collection.
/// [id] is the ID of the document.
Future<Map<String, dynamic>> deleteDocument({
  required String collectionName,
  required String id,
}) async {
  try {
    final docRef = firestore.collection(collectionName).doc(id);
    await docRef.delete();

    return {'success': true};
  } catch (error) {
    return {'error': error.toString()};
  }
}

/// Query documents from a Firestore collection with conditions as a stream.
/// [collectionName] is the name of the Firestore collection.
/// [conditions] is a list of conditions (field, operator, value).
Stream<Map<String, dynamic>> multipleQueryDocumentsStream({
  required String collectionName,
  required List<List<dynamic>> conditions,
}) {
  try {
    CollectionReference collection = firestore.collection(collectionName);

    Query query = collection;

    for (var condition in conditions) {
      query = query.where(condition[0], isEqualTo: condition[1]);
    }

    return query.snapshots().map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return {'documents': []}; // Return empty array if no matching documents
      }

      final documents = querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      return {'documents': documents};
    });
  } catch (error) {
    return Stream.value({'error': error.toString()});
  }
}
/// Retrieves documents from Firestore as a stream based on query conditions.
/// [collectionName] is the name of the Firestore collection.
/// [fieldName] is the name of the field to query against.
/// [fieldValue] is the value to match in the query.
///
/// Returns a stream of documents in a map format. If an error occurs,
/// the stream will return an error message.
Stream<Map<String, dynamic>> queryDocumentsStream({
  required String collectionName,
  required String fieldName,
  required dynamic fieldValue,
}) {
  try {
    // Get the collection reference
    CollectionReference collection = firestore.collection(collectionName);

    // Build the query by applying a 'where' condition on the given field
    Query query = collection.where(fieldName, isEqualTo: fieldValue);

    // Return the stream of documents with necessary formatting
    return query.snapshots().map((querySnapshot) {
      // If no documents match the query, return an empty list
      if (querySnapshot.docs.isEmpty) {
        return {'documents': []};
      }

      // Map the documents to a list with their data and document ID
      final documents = querySnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
      }).toList();

      // Return the formatted documents
      return {'documents': documents};
    });
  } catch (error) {
    // If an error occurs, return it as part of the stream
    return Stream.value({'error': error.toString()});
  }
}
