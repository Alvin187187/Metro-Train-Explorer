import SwiftUI
import MapKit

@main
struct MetroTrainApp: App {
    var body: some Scene {
        WindowGroup {
            DELLOMAS_LabMidtermApp()
                .preferredColorScheme(.dark)
        }
    }
}

enum RailLine: String, CaseIterable {
    case lrt1 = "LRT-1", lrt2 = "LRT-2", mrt3 = "MRT-3"
    var color: Color {
        switch self {
        case .lrt1: return .green
        case .lrt2: return .purple
        case .mrt3: return .blue
        }
    }
}

struct Station: Identifiable {
    let id = UUID()
    let name: String
    let baseFare: Double
    let line: RailLine
    let coordinate: CLLocationCoordinate2D
}

struct QuizQuestion {
    let question: String
    let options: [String]
    let correctAnswer: String
}

struct DELLOMAS_LabMidtermApp: View {
    @State private var isLoggedIn = false
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var userType = "Regular"
    @State private var rememberMe = true
    @State private var showExitAlert = false
    @State private var selectedListLine: RailLine = .lrt2
    @State private var currentPage: Page = .home
    
    enum Page { case home, map, list, quiz }
    
    let stations: [Station] = [
        Station(name: "Baclaran", baseFare: 13, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5283, longitude: 120.9984)),
        Station(name: "EDSA", baseFare: 14, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5385, longitude: 121.0004)),
        Station(name: "Libertad", baseFare: 15, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5476, longitude: 120.9985)),
        Station(name: "Gil Puyat", baseFare: 16, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5540, longitude: 120.9970)),
        Station(name: "Vito Cruz", baseFare: 17, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5633, longitude: 120.9948)),
        Station(name: "Quirino", baseFare: 18, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5702, longitude: 120.9915)),
        Station(name: "Pedro Gil", baseFare: 19, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5768, longitude: 120.9883)),
        Station(name: "United Nations", baseFare: 20, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5826, longitude: 120.9846)),
        Station(name: "Central", baseFare: 22, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5926, longitude: 120.9816)),
        Station(name: "Carriedo", baseFare: 23, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.5997, longitude: 120.9816)),
        Station(name: "Doroteo Jose", baseFare: 23, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6053, longitude: 120.9818)),
        Station(name: "Bambang", baseFare: 24, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6111, longitude: 120.9823)),
        Station(name: "Tayuman", baseFare: 25, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6166, longitude: 120.9827)),
        Station(name: "Blumentritt", baseFare: 26, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6227, longitude: 120.9834)),
        Station(name: "Abad Santos", baseFare: 27, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6305, longitude: 120.9850)),
        Station(name: "R. Papa", baseFare: 28, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6360, longitude: 120.9877)),
        Station(name: "5th Avenue", baseFare: 29, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6444, longitude: 120.9836)),
        Station(name: "Monumento", baseFare: 30, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6542, longitude: 120.9838)),
        Station(name: "Balintawak", baseFare: 33, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6575, longitude: 121.0006)),
        Station(name: "Fernando Poe Jr.", baseFare: 35, line: .lrt1, coordinate: CLLocationCoordinate2D(latitude: 14.6576, longitude: 121.0211)),
        //-----------
        Station(name: "Recto", baseFare: 13, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6038, longitude: 120.9839)),
        Station(name: "Legarda", baseFare: 15, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6008, longitude: 120.9901)),
        Station(name: "Pureza", baseFare: 16, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6020, longitude: 121.0050)),
        Station(name: "V. Mapa", baseFare: 18, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6042, longitude: 121.0116)),
        Station(name: "J. Ruiz", baseFare: 19, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6105, longitude: 121.0252)),
        Station(name: "Gilmore", baseFare: 21, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6135, longitude: 121.0343)),
        Station(name: "Betty Go", baseFare: 22, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6174, longitude: 121.0423)),
        Station(name: "Cubao (L2)", baseFare: 23, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6225, longitude: 121.0531)),
        Station(name: "Anonas", baseFare: 25, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6281, longitude: 121.0643)),
        Station(name: "Katipunan", baseFare: 26, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6310, longitude: 121.0722)),
        Station(name: "Santolan", baseFare: 28, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6219, longitude: 121.0858)),
        Station(name: "Marikina", baseFare: 31, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6247, longitude: 121.1062)),
        Station(name: "Antipolo", baseFare: 33, line: .lrt2, coordinate: CLLocationCoordinate2D(latitude: 14.6255, longitude: 121.1231)),
        //-----------
        Station(name: "North Ave", baseFare: 13, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.6521, longitude: 121.0323)),
        Station(name: "Quezon Ave", baseFare: 13, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.6415, longitude: 121.0383)),
        Station(name: "GMA Kamuning", baseFare: 16, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.6362, longitude: 121.0433)),
        Station(name: "Cubao (M3)", baseFare: 16, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.6195, longitude: 121.0511)),
        Station(name: "Santolan (M3)", baseFare: 20, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.6078, longitude: 121.0563)),
        Station(name: "Ortigas", baseFare: 20, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.5878, longitude: 121.0567)),
        Station(name: "Shaw Blvd", baseFare: 20, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.5813, longitude: 121.0536)),
        Station(name: "Boni", baseFare: 24, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.5737, longitude: 121.0483)),
        Station(name: "Guadalupe", baseFare: 24, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.5672, longitude: 121.0454)),
        Station(name: "Buendia", baseFare: 24, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.5542, longitude: 121.0348)),
        Station(name: "Ayala", baseFare: 28, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.5490, longitude: 121.0280)),
        Station(name: "Magallanes", baseFare: 28, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.5420, longitude: 121.0195)),
        Station(name: "Taft Ave", baseFare: 28, line: .mrt3, coordinate: CLLocationCoordinate2D(latitude: 14.5376, longitude: 121.0013))
    ]
    
    let quizQuestions = [
        QuizQuestion(question: "Which train line provides access to Intramuros via Central Terminal Station?", options: ["LRT-1", "LRT-2", "MRT-3", "PNR"], correctAnswer: "LRT-1"),
        QuizQuestion(question: "Which LRT-2 station is closest to the TIP Manila?", options: ["Legarda", "Recto", "Pureza", "V. Mapa"], correctAnswer: "Legarda"),
        QuizQuestion(question: "Which MRT-3 station is directly connected to SM Megamall?", options: ["Shaw Boulevard", "Ortigas", "Boni", "Guadalupe"], correctAnswer: "Ortigas"),
        QuizQuestion(question: "Which LRT-1 station is near Rizal Park (Luneta)?", options: ["United Nations", "Pedro Gil", "Quirino", "Vito Cruz"], correctAnswer: "United Nations"),
        QuizQuestion(question: "Araneta City (Gateway Mall & Smart Araneta Coliseum) is accessible from which stations?", options: ["LRT-2 Cubao only", "MRT-3 Cubao only", "Both LRT-2 and MRT-3 Cubao", "Shaw Boulevard"], correctAnswer: "Both LRT-2 and MRT-3 Cubao"),
        QuizQuestion(question: "Which LRT-2 station is closest to Ateneo de Manila University and Miriam College?", options: ["Anonas", "Katipunan", "Santolan", "Marikina"], correctAnswer: "Katipunan"),
        QuizQuestion(question: "Which MRT-3 station serves the Makati Central Business District (Ayala Avenue area)?", options: ["Buendia", "Ayala", "Magallanes", "Taft Avenue"], correctAnswer: "Ayala"),
        QuizQuestion(question: "Which LRT-1 station is near the Cultural Center of the Philippines (CCP)?", options: ["Gil Puyat", "Libertad", "EDSA", "Baclaran"], correctAnswer: "Gil Puyat"),
        QuizQuestion(question: "Which LRT-2 station is closest to PUP (Polytechnic University of the Philippines)?", options: ["Pureza", "Legarda", "Cubao", "Recto"], correctAnswer: "Pureza"),
        QuizQuestion(question: "Which MRT-3 station gives access to Bonifacio Global City (via nearby transport links)?", options: ["Guadalupe", "Boni", "Shaw Boulevard", "Ortigas"], correctAnswer: "Guadalupe"),
        QuizQuestion(question: "Which LRT-1 station is commonly used to visit Quiapo Church?", options: ["Carriedo", "Doroteo Jose", "Bambang", "Tayuman"], correctAnswer: "Carriedo"),
        QuizQuestion(question: "Which LRT-2 station is closest to SM City Sta. Mesa?", options: ["V. Mapa", "J. Ruiz", "Gilmore", "Anonas"], correctAnswer: "V. Mapa"),
        QuizQuestion(question: "Which MRT-3 station is near EDSA Shrine?", options: ["North Avenue", "Ortigas", "Santolan-Annapolis", "Shaw Boulevard"], correctAnswer: "Ortigas"),
        QuizQuestion(question: "Which LRT-1 station provides access to Manila City Hall?", options: ["Central Terminal", "United Nations", "Pedro Gil", "Monumento"], correctAnswer: "Central Terminal"),
        QuizQuestion(question: "Which station allows transfer between LRT-1 and MRT-3 near Taft Avenue?", options: ["EDSA (LRT-1) / Taft Avenue (MRT-3)", "Cubao", "Recto", "North Avenue"], correctAnswer: "EDSA (LRT-1) / Taft Avenue (MRT-3)")
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showScoreAlert = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 14.60, longitude: 121.03),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if !isLoggedIn { loginView } else { mainAppView }
        }
    }
    
    var loginView: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack(spacing: 5) {
                Image(systemName: "tram.fill").font(.system(size: 60)).foregroundColor(.green)
                Text("METRO TRAIN EXPLORER").font(.system(size: 24, weight: .black, design: .monospaced))
                Text("Guide for Commuters").font(.caption).foregroundColor(.green)
            }
            VStack(spacing: 15) {
                customTextField(placeholder: "Full Name", text: $username)
                customTextField(placeholder: "Email Address", text: $email)
                HStack {
                    Text("Classification").font(.subheadline).foregroundColor(.gray)
                    Spacer()
                    Picker("User Type", selection: $userType) {
                        Text("Regular").tag("Regular")
                        Text("Student").tag("Student")
                        Text("Senior/PWD").tag("Senior")
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .accentColor(.green)
                Toggle(isOn: $rememberMe) {
                    Text("Remember Account").font(.subheadline).foregroundColor(.gray)
                }
                .tint(.green)
                .padding(.horizontal, 5)
            }
            .padding(.horizontal)
            Button(action: { withAnimation { isLoggedIn = true } }) {
                Text("START YOUR JOURNEY").font(.headline).frame(maxWidth: .infinity).padding().background(Color.green).foregroundColor(.black).cornerRadius(12)
            }
            .padding(.horizontal)
            Button("Exit Application") { showExitAlert = true }.foregroundColor(.red).font(.footnote)
                .alert("Are you sure to exit?", isPresented: $showExitAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Exit", role: .destructive) { exit(0) }
                }
            Spacer()
        }
    }
    
    var mainAppView: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    Text("SYSTEM ACTIVE").font(.caption2).foregroundColor(.green)
                    Text("Hi, \(username.isEmpty ? "Commuter" : username.uppercase())!").font(.headline).bold()
                }
                Spacer()
                Button(action: { isLoggedIn = false }) {
                    Image(systemName: "power").foregroundColor(.red).padding(10).background(Circle().fill(Color.white.opacity(0.1)))
                }
            }
            .padding()
            HStack(spacing: 10) {
                navButton(title: "MAP", icon: "map.fill", page: .map)
                navButton(title: "FARES", icon: "list.bullet", page: .list)
                navButton(title: "QUIZ", icon: "brain", page: .quiz)
            }
            .padding(.horizontal)
            ZStack {
                RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.05)).padding()
                Group {
                    if currentPage == .home { homeContent }
                    else if currentPage == .map { mapView }
                    else if currentPage == .list { stationListView }
                    else if currentPage == .quiz { quizView }
                }
                .padding(30)
            }
        }
    }
    
    var homeContent: some View {
        VStack(spacing: 20) {
            Text("🚆").font(.system(size: 80))
            Text("Welcome to Metro Train").font(.headline)
            Text("Be guided to your commute. Access full station lists for LRT-1, LRT-2, and MRT-3 lines across Metro Manila.").multilineTextAlignment(.center).foregroundColor(.gray)
        }
    }
    
    var mapView: some View {
        Map(coordinateRegion: $region, annotationItems: stations) { station in
            MapAnnotation(coordinate: station.coordinate) {
                VStack(spacing: 0) {
                    Text(station.name).font(.system(size: 8, weight: .bold)).padding(4).background(Color.black.opacity(0.8)).cornerRadius(5)
                    Image(systemName: "mappin.circle.fill").font(.title2).foregroundColor(station.line.color)
                }
            }
        }
        .cornerRadius(15)
    }
    
    var stationListView: some View {
        VStack {
            HStack {
                ForEach(RailLine.allCases, id: \.self) { line in
                    Button(action: { selectedListLine = line }) {
                        Text(line.rawValue).font(.caption.bold()).frame(maxWidth: .infinity).padding(8)
                            .background(selectedListLine == line ? line.color : Color.white.opacity(0.1))
                            .foregroundColor(selectedListLine == line ? .black : .white).cornerRadius(8)
                    }
                }
            }
            .padding(.bottom, 10)
            ScrollView {
                VStack(spacing: 12) {
                    HStack {
                        Text("STATION").font(.caption2).foregroundColor(.gray)
                        Spacer()
                        Text("REGULAR / 50% DISC.").font(.caption2).foregroundColor(.gray)
                    }
                    ForEach(stations.filter { $0.line == selectedListLine }) { station in
                        HStack {
                            Text(station.name).bold()
                            Spacer()
                            Text("P\(Int(station.baseFare))")
                            Text("P\(Int(station.baseFare * 0.5))").foregroundColor(.green).bold()
                        }
                        .padding().background(Color.white.opacity(0.08)).cornerRadius(12)
                    }
                }
            }
        }
    }
    
    var quizView: some View {
        VStack(spacing: 15) {
            Text("KNOWLEDGE TRIVIA CHECK").font(.caption).bold().foregroundColor(.green)
            Text("Question \(currentQuestionIndex + 1) / \(quizQuestions.count)").font(.system(.caption, design: .monospaced))
            Text(quizQuestions[currentQuestionIndex].question).font(.title3).bold().multilineTextAlignment(.center).frame(minHeight: 80)
            ForEach(quizQuestions[currentQuestionIndex].options, id: \.self) { option in
                Button(action: { handleQuizAnswer(option) }) {
                    Text(option).frame(maxWidth: .infinity).padding().background(Color.white.opacity(0.1)).cornerRadius(10).foregroundColor(.white)
                }
            }
        }
        .alert("Quiz has finished", isPresented: $showScoreAlert) {
            Button("Restart") { currentQuestionIndex = 0; score = 0; currentPage = .home }
        } message: {
            Text("Score: \(score) / \(quizQuestions.count)")
        }
    }
    
    func customTextField(placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text).padding().background(Color.white.opacity(0.1)).cornerRadius(10).foregroundColor(.white)
    }
    
    func navButton(title: String, icon: String, page: Page) -> some View {
        Button(action: { currentPage = page }) {
            VStack {
                Image(systemName: icon)
                Text(title).font(.system(size: 10, weight: .bold))
            }
            .frame(maxWidth: .infinity).padding(.vertical, 12)
            .background(currentPage == page ? Color.green : Color.white.opacity(0.1))
            .foregroundColor(currentPage == page ? .black : .white).cornerRadius(12)
        }
    }
    
    func handleQuizAnswer(_ answer: String) {
        if answer == quizQuestions[currentQuestionIndex].correctAnswer { score += 1 }
        if currentQuestionIndex + 1 < quizQuestions.count {
            withAnimation { currentQuestionIndex += 1 }
        } else {
            showScoreAlert = true
        }
    }
}   