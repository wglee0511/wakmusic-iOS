import RxSwift
import DataMappingModule
import ErrorModule
import Foundation

public protocol SongsRepository {
    func fetchSearchSong(type: SearchType, keyword: String) -> Single<[SongEntity]>
    func fetchLyrics(id: String) -> Single<[LyricsEntity]>
}