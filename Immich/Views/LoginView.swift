import SwiftUI

struct LoginView: View {
    @EnvironmentObject var model: ImmichModel
    @State private var loadingState: LoadingState<User>?
    @State private var hasValidAuthToken: Bool?

    @State private var server: String = "https://demo.immich.app/api"
    @State private var email: String = "demo@immich.app"
    @State private var password: String = "demo"

    @Binding var isLoggedIn: Bool

    var body: some View {
        if let hasValidAuthToken, !hasValidAuthToken {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .opacity(0.1)
                VStack {
                    Image("immich-logo", bundle: nil)
                    errorView
                    Text("Login")
                        .font(.title2)
                    TextField("Server", text: $server)
                        .textContentType(.URL)
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                    progressButtonView
                }
                .padding(50)
            }
            .frame(width: 700, height: 900)
        } else {
            ProgressView()
                .task {
                    do {
                        hasValidAuthToken = try await model.validateAccessToken()
                        isLoggedIn = hasValidAuthToken ?? false
                    } catch {
                        hasValidAuthToken = false
                    }
                }
        }
    }

    @ViewBuilder
    var errorView: some View {
        if let loadingState, case .failure(let error) = loadingState {
            Text(error.localizedDescription)
                .foregroundColor(.red)
        }
    }

    @ViewBuilder
    var progressButtonView: some View {
        if let loadingState, case .loading = loadingState {
            ProgressView()
        } else {
            Button("Login") {
                login()
            }
        }
    }

    private func login() {
        Task {
            do {
                loadingState = .loading
                let user = try await model.login(server: server, email: email, password: password)
                loadingState = .content(user)
                isLoggedIn = true
            } catch {
                loadingState = .failure(error)
            }
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
        .environmentObject(ImmichModel())
}
