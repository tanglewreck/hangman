// The Swift Programming Language
// https://docs.swift.org/swift-book

// TODO:
//      – Use gameStatus throughout (don't send as arguments)
//      – Read wordlist from file (JSON?)
//          let s = try! String(contentsOfFile: "Package.swift", encoding: .utf8) 
//
import Cocoa  // Needed for exit(); alternatively, import Foundation

/* TEST CODE:
import System
let message: String = "This is a log message."
let path: FilePath = "/Users/mier/foomessage.txt"
print(message, path)
let fd = try FileDescriptor.open(path, .writeOnly, options: .append)
// print(fd, path)
// try fd.closeAfter { try fd.writeAll(message.utf8) }
*/


// Top-Level Code goes here
guard let hangman = Hangman() else {
    print("Failed to create game")
    exit(-1)
}

// print("secretWord: \(hangman.secretWord)")
hangman.gameLoop()
