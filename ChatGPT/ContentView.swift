import SwiftUI
import OpenAISwift

let apiKey = ProcessInfo.processInfo.environment["OPENAI_TOKEN"]!
let openAI = OpenAISwift(authToken: apiKey)

func chatGPT(request: String) async -> String {
    do {
        let result = try await openAI.sendCompletion(with: request, maxTokens: 500)
        return result.choices.first!.text
    } catch {
        print(error.localizedDescription)
    }
    return "Ошибка"
}

struct ContentView: View {
    @State var userRequest = ""
    @State var gptAnswer = ""
    
    var body: some View {
        VStack {
            Text(gptAnswer)
            Spacer()
            HStack {
                TextField("Запрос", text: $userRequest, prompt: Text("Введите"))
                Button("Отправить") {
                    Task {
                        let answer = await chatGPT(request: userRequest)
                        let splitted = answer.split(separator: "\n")
                        gptAnswer = String(splitted[1])
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
