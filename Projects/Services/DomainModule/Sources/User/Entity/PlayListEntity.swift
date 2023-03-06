import Foundation

public struct PlayListEntity: Equatable {
    public init(
        id: Int,
        key:String,
        title:String,
        creator_id:String,
        image:String,
        songlist:[String]
     
    ) {
        self.id = id
        self.key = key
        self.title = title
        self.creator_id = creator_id
        self.image = image
        self.songlist = songlist
        
    }
    
    public let id: Int
    public let key,title,creator_id,image:String
    public let songlist:[String]
    
}