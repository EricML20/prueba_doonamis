//
//  ContentView.swift
//  prueba-doonamis
//
//  Created by Eric Melé Lorite on 5/7/23.
//

import SwiftUI

struct Movie: Identifiable {
    let id: Int
    let name: String
    let popularity: CGFloat
    let overview: String
    let backdrop_path: String
    let vote_average: CGFloat
    let vote_count: Int
    let genre_ids: [Int]
    let poster_path: String
}

struct Language: Identifiable {
    var id: Int
    let title: String
    let name: String
    let flag: String
}

struct ContentView: View {
    
    @State private var movies: [Movie] = []
    
    private var languages: [Language] = [
        Language(id: 1, title: "Most popular movies", name: "en-US", flag: "us"),
        Language(id: 2, title: "Películas más populares", name: "es-ES", flag: "es"),
        Language(id: 3, title: "Films les plus populaires", name: "fr-FR", flag:"fr"),
        Language(id: 4, title: "Die beliebtesten filme", name: "de-DE", flag: "de"),
        Language(id: 5, title: "Film più popolari", name: "it-IT", flag: "it")
    ]
    @State private var language_selected: Language = Language(id: 1, title: "Most popular movies", name: "en-US", flag: "us")
    
    func handleTVShows() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/tv/popular?language=\(language_selected.name)&page=1&api_key=c6aeee577586ba38e487b74dfede5deb")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
              if let data = data {
                  do {
                      if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                          print("JSON Response:\n\(json)")
                          if let jsonMovies = json["results"] as? [[String: Any]] {
                                      movies = jsonMovies.compactMap { movieData in
                                          guard let id = movieData["id"] as? Int,
                                                let name = movieData["name"] as? String,
                                                let popularity = movieData["popularity"] as? CGFloat,
                                                let overview = movieData["overview"] as? String,
                                                let backdrop_path = movieData["backdrop_path"] as? String,
                                                let vote_average = movieData ["vote_average"] as? CGFloat,
                                                let vote_count = movieData["vote_count"] as? Int,
                                                let genre_ids = movieData["genre_ids"] as? [Int],
                                                let poster_path = movieData["poster_path"] as? String
                                          else {
                                              return nil
                                          }
                                          return Movie(id: id, name: name, popularity: popularity, overview: overview, backdrop_path: backdrop_path, vote_average: vote_average, vote_count: vote_count, genre_ids: genre_ids, poster_path: poster_path)
                                      }
                                      movies.sort(by: { $0.popularity > $1.popularity })
                                  }
                      }
                  } catch {
                      print("Error converting data to JSON: \(error)")
                  }
              }
          }
        })

        dataTask.resume()
        
    }
    
    var body: some View {
        NavigationView {
            List(movies) { movie in
                HStack {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w92/" + movie.backdrop_path))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .scaledToFit()
                        .clipped()
                    
                    NavigationLink(destination: DetailsMovies(selected_movie: movie)){
                        Text(movie.name)
                    }
                    .padding()
                }
            }
            .background(Color("BackgroundColor"))
            .scrollContentBackground(.hidden)
            .navigationTitle(language_selected.title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(languages) { language in
                            Button(action: {
                                language_selected = language
                                handleTVShows()
                            }) {
                                HStack {
                                    Image(language.flag)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text(language.name)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "globe")
                    }
                }
            }
        }
        .onAppear {
            handleTVShows()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
