import Moya
import DataMappingModule
import ErrorModule
import Foundation
import KeychainModule

public enum LikeAPI {
    case fetchLikeNumOfSong(id:String)
    case addLikeSong(id:String)
    case cancelLikeSong(id:String)
}



extension LikeAPI: WMAPI {

    public var domain: WMDomain {
        .like
    }

    public var urlPath: String {
        switch self {
            
        case .fetchLikeNumOfSong(id: let id):
            return "/\(id)"
        case .addLikeSong(id: let id):
            return "/\(id)/addLike"
        case .cancelLikeSong(id: let id):
            return "/\(id)/removeLike"
        }
    }
        
    public var method: Moya.Method {
        switch self {
      
        case .fetchLikeNumOfSong:
            return .get
        case .addLikeSong,.cancelLikeSong:
            return .post
        }
    }
    
    public var task: Moya.Task {
        return .requestPlain
        
    }

    public var headers: [String : String]? {
        let token: String = KeychainImpl().load(type: .accessToken)
        switch self {
            
        case .fetchLikeNumOfSong:
            return ["Content-Type": "application/json"]
        case .addLikeSong,.cancelLikeSong:
            return ["Authorization":"Bearer \(token)"]
        }
    }
        
    public var jwtTokenType: JwtTokenType {
        return .none
    }
    
    public var errorMap: [Int: WMError] {
        switch self {
        default:
            return [
                400: .badRequest,
                401: .tokenExpired,
                404: .notFound,
                429: .tooManyRequest,
                500: .internalServerError
            ]
        }
    }
}
