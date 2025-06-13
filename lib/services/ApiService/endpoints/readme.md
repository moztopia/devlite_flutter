# API Endpoints Guide

This directory (`lib/services/ApiService/endpoints/`) centralizes all API calls in your application. Each file in this directory typically corresponds to a specific feature or resource group and contains functions for making requests to related API routes.

## How to Create a New Endpoint File

1.  **Create a new file:** In this directory, create a new Dart file named `endpoint_your_feature.dart` (e.g., `endpoint_products.dart`).
2.  **Import `api_service.dart`:** All endpoint files must import `package:devlite_flutter/services/ApiService/api_service.dart` to access the `ApiService` instance.
3.  **Define functions for your API calls:** Each function should encapsulate a specific API request (GET, POST, PUT, PATCH, DELETE).

### Example Structure: `lib/services/ApiService/endpoints/endpoint_sample.dart`

```dart
import 'package:dio/dio.dart';
import 'package:devlite_flutter/services/ApiService/api_service.dart';

// --- Authenticated Examples ---

/// Fetches a list of items. Requires authentication.
Future<Response> getSampleItems({Map<String, dynamic>? queryParameters}) {
  return ApiService().get('/items', queryParameters: queryParameters);
}

/// Creates a new item. Requires authentication.
Future<Response> createSampleItem({required Map<String, dynamic> data}) {
  return ApiService().post('/items', data: data);
}

/// Updates an existing item. Requires authentication.
Future<Response> updateSampleItem({required String itemId, required Map<String, dynamic> data}) {
  return ApiService().put('/items/$itemId', data: data);
}

/// Partially updates an existing item. Requires authentication.
Future<Response> patchSampleItem({required String itemId, required Map<String, dynamic> data}) {
  return ApiService().patch('/items/$itemId', data: data);
}

/// Deletes an item. Requires authentication.
Future<Response> deleteSampleItem({required String itemId}) {
  return ApiService().delete('/items/$itemId');
}

// --- Anonymous Examples ---

// These paths should be added to `anonymousPaths` in ApiService initialization.
// Anonymous paths are an explicit action. Endpoints are assumed to require
// authentication.

/// Authenticates a user (e.g., login).
Future<Response> postAnonymousLogin({required Map<String, dynamic> credentials}) {
  return ApiService().post('/auth/login', data: credentials);
}

/// Fetches public data without authentication.
Future<Response> getPublicData() {
  return ApiService().get('/public/data');
}
```

**Note on Authentication:**

- `ApiService` automatically handles adding the `Authorization` header with a bearer token if a `tokenProvider` is configured during its initialization in `startup_process.dart`.
- If an API endpoint does **not** require authentication, its path must be explicitly added to the `anonymousPaths` list when initializing `ApiService` in `startup_process.dart`. The `endpoint_welcome.dart` file serves as an existing example of an anonymous endpoint.

## Registering New Endpoints

For your new endpoint functions to be accessible throughout the application, you must export their containing file from `lib/services/ApiService/endpoints/endpoints.dart`.

### Modify `lib/services/ApiService/endpoints/endpoints.dart`

Add an `export` statement for your new file:

```dart
export 'package:devlite_flutter/services/ApiService/endpoints/endpoint_welcome.dart';
export 'package:devlite_flutter/services/ApiService/endpoints/endpoint_sample.dart'; // Add this line
// ... other exports for your feature-specific endpoints
```

## Using Endpoints in Other Files

Once your endpoint file is created and exported, you can easily call its functions from any part of your application.

1.  **Import `services.dart`:** This file exports all necessary services, including your new API endpoints.

    ```dart
    import 'package:devlite_flutter/services/services.dart';
    ```

2.  **Call the endpoint function:**

    ```dart
    import 'package:flutter/material.dart';
    import 'package:devlite_flutter/services/services.dart';
    import 'package:devlite_flutter/utilities/utilities.dart'; // For mozPrint

    // Example: A simple data model for demonstration
    class Item {
      final String id;
      final String name;
      final int quantity;

      Item({required this.id, required this.name, required this.quantity});

      factory Item.fromJson(Map<String, dynamic> json) {
        return Item(
          id: json['id'],
          name: json['name'],
          quantity: json['quantity'],
        );
      }
    }

    class MyScreen extends StatefulWidget {
      const MyScreen({super.key});

      @override
      State<MyScreen> createState() => _MyScreenState();
    }

    class _MyScreenState extends State<MyScreen> {
      Item? _item;
      String _errorMessage = '';

      @override
      void initState() {
        super.initState();
        _fetchItem();
      }

      Future<void> _fetchItem() async {
        try {
          // Example: Calling the getSampleItems endpoint
          final response = await getSampleItems(queryParameters: {'limit': 1});
          if (response.statusCode == 200 && response.data != null && response.data is List && response.data.isNotEmpty) {
            setState(() {
              _item = Item.fromJson(response.data[0]);
              _errorMessage = '';
            });
            mozPrint('Fetched item: ${_item?.name}', 'API_USAGE', 'SUCCESS');
          } else {
            setState(() {
              _errorMessage = 'Failed to load item: Status ${response.statusCode}';
            });
            mozPrint('Failed to load item: Status ${response.statusCode}', 'API_USAGE', 'ERROR');
          }
        } catch (e) {
          setState(() {
            _errorMessage = 'Error fetching item: $e';
          });
          mozPrint('Error fetching item: $e', 'API_USAGE', 'ERROR');
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('API Usage Example')),
          body: Center(
            child: _errorMessage.isNotEmpty
                ? Text(_errorMessage)
                : (_item == null
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Item ID: ${_item!.id}'),
                          Text('Item Name: ${_item!.name}'),
                          Text('Quantity: ${_item!.quantity}'),
                        ],
                      )),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _fetchItem,
            child: const Icon(Icons.refresh),
          ),
        );
      }
    }
    ```
