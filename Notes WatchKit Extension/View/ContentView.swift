//
//  ContentView.swift
//  Notes WatchKit Extension
//
//  Created by Ashish Sharma on 01/04/2023.
//

import SwiftUI

struct ContentView: View {
    //MARK: - PROPERTIES
    @AppStorage("lineCount") var lineCount: Int = 1
    
    @State private var notes:[Note] = [Note]()
    @State private var text: String = ""
    
    //MARK: FUNCTIONS
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        return path[0]
    }
    
    func save() {
//        dump(notes) //dumps in console
        
        do {
            //1. Convert the notes array to data using JSONEncoder
            let data = try JSONEncoder().encode(notes)
            
            //2. Create a new URL to save the file using the getDocumentDirectory
            let url = getDocumentDirectory().appendingPathComponent("notes")
            
            //3. Write the data to the given URL
            try data.write(to: url)
        } catch {
            print("Saving data has failed! \(error)")
        }
    }
    
    func load() {
        // This should be delayed and not immediately when the propgram appears.When swiftUIisprocessing to load the app, it can get confused and the load function may have completed before other things are done by swiftUI. So a delay is necessary. All data loads should have adelay associated with them through asynchronous programming.
        DispatchQueue.main.async {
            //perform these steps at a later moment that isn't right now
            do{
                //1. get the notes url path
                let url = getDocumentDirectory().appendingPathComponent("notes")
                
                //2. create a new property for data
                let data = try Data(contentsOf: url)
                
                //3. decode the data
                notes = try JSONDecoder().decode([Note].self, from: data)   // The decodable protocol is the struct according to which the datawill be decoded
                
                
            } catch {
                print("Failed to load data! \(error)")
            }
        }
        
    }
    
    func delete(offsets: IndexSet) {
        withAnimation {
            notes.remove(atOffsets: offsets)
            save()
        }
    }
    
    //MARK: - BODY
    
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 6){
                TextField("Add New Note", text: $text)
                
                Button {
                    //ACTION
                    //1. Only run the button's action when the text field is not empty
                    guard text.isEmpty == false else { return }
                    
                    //2. Create a new note item and initialize it with the text value
                    let note = Note(id: UUID(), text: text)
                    
                    //3. Add the new note item to the notes array (append)
                    notes.append(note)
                    
                    //4. Make the text field empty
                    text = ""
                    
                    //5. Save the notes (function)
                    save()
                   
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 42, weight: .semibold))
                }
                .fixedSize()
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.accentColor)
                .buttonStyle(BorderedButtonStyle(tint: .accentColor))
            } //: HSTACK
            Spacer()
            if notes.count >= 1{
                List{
                    ForEach(0..<notes.count, id: \.self) { i in
                        NavigationLink (destination: DetailView(note: notes[i], count: notes.count, index: i)){
                            HStack{
                                Capsule()
                                    .frame(width: 4)
                                    .foregroundColor(.accentColor)
                                
                                Text(notes[i].text)
                                    .lineLimit(lineCount)
                                    .padding(.leading, 5)
                            } //: HSTACK
                        }
                    } //: FOREACH
                    .onDelete(perform: delete)
                } //: LIST
            } else {
                Spacer()
                Image(systemName: "note.text")
                    .resizable().scaledToFit()
                    .foregroundColor(.gray)
                    .opacity(0.25)
                    .padding(5)
                Spacer()
            }
        } //: VSTACK
        .navigationTitle("Notes")
        .onAppear {
            load()
        }
        
    }
}

//MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
