import Foundation
import Combine

public class ViewModelTienda: ObservableObject {
    // Public properties to hold user and benefit data
    @Published var beneficios: [BENEFICIOS] = []
    @Published var usuario: USUARIOS?
    @Published var errorMessage: String?
    @Published var currentBenefitDescription: String?
    @Published var puntosUsuario: Int = 0
    @Published var responseMessage: String?

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Fetch All Benefits
    public func fetchBeneficios() {
        guard let url = URL(string: "\(urlEndpoint)/beneficios") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [BENEFICIOS].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { beneficios in
                self.beneficios = beneficios
            })
            .store(in: &cancellables)
    }

    

    // MARK: - Fetch User Points
    public func fetchPuntosUsuario(by userId: Int) {
            guard let url = URL(string: "\(urlEndpoint)/usuario/puntos?userId=\(userId)") else { return }

            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [String: Int].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // Manejo del error (puedes asignar un mensaje a una propiedad de error si lo deseas)
                        print("Error fetching points: \(error.localizedDescription)")
                    }
                }, receiveValue: { points in
                    if let puntos = points["puntos"] {
                        self.puntosUsuario = puntos // Asigna los puntos a la propiedad
                        print("User points: \(puntos)")
                    }
                })
                .store(in: &cancellables)
        }

    // MARK: - Fetch Benefit Description
    public func fetchDescripcionBeneficio(by benefitId: Int) {
            guard let url = URL(string: "\(urlEndpoint)/beneficio/descripcion?beneficioId=\(benefitId)") else { return }

            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: [String: String].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                }, receiveValue: { description in
                    if let desc = description["descripcion"] {
                        self.currentBenefitDescription = desc // Almacenar la descripción aquí
                    }
                })
                .store(in: &cancellables)
        }


    // MARK: - Validate and Assign Benefit
    public func nuevoBeneficioUsuario(idBeneficio: Int, idUsuario: Int, puntosUsuario: Int, puntosBeneficio: Int) {
            guard let url = URL(string: "\(urlEndpoint)/usuarios/beneficio") else { return }

            let parameters: [String: Any] = [
                "id_beneficio": idBeneficio,
                "id_usuario": idUsuario,
                "puntos_usuario": puntosUsuario,
                "puntos_beneficio": puntosBeneficio
            ]

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                    return
                }
                guard let data = data else { return }
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = jsonResponse["message"] as? String {
                    DispatchQueue.main.async {
                        self.responseMessage = message // Almacena el mensaje de respuesta
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to assign benefit."
                    }
                }
            }.resume()
        }
}


struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}
