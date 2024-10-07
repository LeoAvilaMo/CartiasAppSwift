import Foundation

// Simple function to handle login
func loginUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
    if username == "Admin" && password == "admin" {
        print("Admin login successful") // Print for admin login success
        DispatchQueue.main.async {
            completion(true) // Admin login successful
        }
        return
    }

    guard let url = URL(string: "\(urlEndpoint)/login") else {
        print("Invalid URL") // Print when URL is invalid
        DispatchQueue.main.async {
            completion(false)
        }
        return
    }

    // Create the request body
    let body: [String: Any] = [
        "email": username,
        "contrasena": password
    ]

    // Convert the body to JSON
    let jsonData = try? JSONSerialization.data(withJSONObject: body)

    // Configure the POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData

    // Send the request
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)") // Print error if request fails
            DispatchQueue.main.async {
                completion(false) // Login failed due to error
            }
            return
        }

        // Handle the response
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)") // Print status code
            if httpResponse.statusCode == 200, let data = data {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let message = jsonResponse["message"] as? String, message == "Login successful" {
                        print("Login successful") // Print on successful login
                        DispatchQueue.main.async {
                            completion(true) // Login successful
                        }
                    } else {
                        print("Credenciales incorrectas") // Print for incorrect credentials
                        DispatchQueue.main.async {
                            completion(false) // Incorrect credentials
                        }
                    }
                }
            } else {
                print("Failed login attempt with status code: \(httpResponse.statusCode)") // Print if status code is not 200
                DispatchQueue.main.async {
                    completion(false) // Failed login
                }
            }
        } else {
            print("Error en el login. Verifica tu usuario y contraseña.") // Print for general login error
            DispatchQueue.main.async {
                completion(false) // Failed login
            }
        }
    }.resume()
}
