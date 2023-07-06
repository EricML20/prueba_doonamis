//
//  DetailsMovies.swift
//  prueba-doonamis
//
//  Created by Eric Melé Lorite on 5/7/23.
//

import SwiftUI

struct Genres: Identifiable {
    let id: Int
    let name: String
}

struct DetailsMovies: View {
    
    @State private var genres: [Genres] = []
    @State var selected_movie: Movie
    
    func getGenres() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/genre/tv/list?language=en&api_key=c6aeee577586ba38e487b74dfede5deb")! as URL,
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
                            if let jsonMovies = json["genres"] as? [[String: Any]] {
                                genres = jsonMovies.compactMap { movieData in
                                    if let id = movieData["id"] as? Int,
                                       let name = movieData["name"] as? String {
                                        return Genres(id: id, name: name)
                                    }
                                    return nil
                                }
                            }
                        }
                    } catch {
                        print("Error al convertir los datos en JSON: \(error)")
                    }
                }
                
            }
        })
        
        dataTask.resume()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text(selected_movie.name)
                    .font(.title2)
                
                HStack() {
                    Spacer()
                    
                    Label("\(selected_movie.popularity, specifier: "%.2f")", systemImage: "chart.line.uptrend.xyaxis")
                    
                    Label("\(selected_movie.vote_count)", systemImage: "person.3")
                    
                    Label("\(selected_movie.vote_average, specifier: "%.1f")", systemImage: "heart")
                    
                    Spacer()
                }
                .font(.caption)
            }
            HStack {
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342/" + selected_movie.poster_path))
                    
                    Text(selected_movie.genre_ids.compactMap { genreID in
                        genres.first { $0.id == genreID }?.name
                        
                    }.joined(separator: ", "))
                    .font(.footnote)
                }
            }
            
            VStack(alignment: .leading) {
                if !selected_movie.overview.isEmpty {
                    Text("Overview")
                        .font(.headline)
               
                    Text(selected_movie.overview)
                        .font(.body)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading) 
            .padding(.horizontal, 25)
            .padding(.top, 10)
            
            Spacer()
        }
        .background(Color("BackgroundColor"))
        .navigationBarTitleDisplayMode(.inline)
        .foregroundColor(Color("AccentColor"))
        .onAppear {
            getGenres()
        }
        
    }
    
    struct DetailsMovies_Previews: PreviewProvider {
        static var previews: some View {
            DetailsMovies(selected_movie: Movie(id: 134224, name: "Voltes V: Legacy", popularity: 1865.967, overview: "Voltes V: Legacy follows the story of three brothers, Steve, Big Bert, and Little Jon Armstrong, and their friends Jamie Robinson and Mark Gordon, as they fight the forces of humanoid aliens known as Boazanians who plans to invade the earth and launch their beast fighters all over the world.", backdrop_path: "/fEP2Sha3PXJnAcoGOjr5oybq44Q.jpg", vote_average: 5.3, vote_count: 6, genre_ids: [10765,10759], poster_path: "/jZ32tdCTFsRoU2GehW6ZzSpTyS1.jpg"))
        }
    }
}
