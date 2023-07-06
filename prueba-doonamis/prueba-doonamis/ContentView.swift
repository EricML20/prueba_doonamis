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
    let first_air_date: String
    let vote_average: CGFloat
    let vote_count: Int
    let genre_ids: [Int]
    let poster_path: String
}

struct ContentView: View {
    
    @State private var movies: [Movie] = []
    
    func handleTVShows() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/tv/popular?language=en-US&page=1&api_key=c6aeee577586ba38e487b74dfede5deb")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error as Any)
          } else {
            let httpResponse = response as? HTTPURLResponse
              //print(httpResponse)
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
                                                let first_air_date = movieData["first_air_date"] as? String,
                                                let vote_average = movieData ["vote_average"] as? CGFloat,
                                                let vote_count = movieData["vote_count"] as? Int,
                                                let genre_ids = movieData["genre_ids"] as? [Int],
                                                let poster_path = movieData["poster_path"] as? String
                                          else {
                                              return nil
                                          }
                                          return Movie(id: id, name: name, popularity: popularity, overview: overview, backdrop_path: backdrop_path, first_air_date: first_air_date, vote_average: vote_average, vote_count: vote_count, genre_ids: genre_ids, poster_path: poster_path)
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
        NavigationView() {
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
            .navigationTitle("Most popular movies")
            
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
