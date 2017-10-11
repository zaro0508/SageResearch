//
//  RSDTaskStepObject.swift
//  ResearchSuite
//
//  Copyright © 2017 Sage Bionetworks. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2.  Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission. No license is granted to the trademarks of
// the copyright holders even if such marks are included in this software.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import Foundation

public struct RSDTaskStepObject: RSDTaskStep, Decodable {
    
    public let type: String
    public let identifier: String
    public let subtaskInfo: RSDTaskInfo
    
    public init(identifier: String, subtaskInfo: RSDTaskInfo, type: String? = nil) {
        self.identifier = identifier
        self.subtaskInfo = subtaskInfo
        self.type = type ?? RSDFactory.StepType.subtask.rawValue
    }
    
    public func instantiateStepResult() -> RSDResult {
        return RSDTaskResultObject(identifier: identifier)
    }
    
    public func validate() throws {
    }
    
    private enum CodingKeys : String, CodingKey {
        case identifier, type, subtaskInfo = "taskInfo"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // get the identifier
        let identifier = try container.decode(String.self, forKey: .identifier)
        self.identifier = identifier
        self.type = try container.decode(String.self, forKey: .type)
        
        // Look first for a task info defined by the data source and then look it to be defined
        // within the container.
        if let taskInfo = decoder.taskDataSource?.taskInfo(with: identifier) {
            self.subtaskInfo = taskInfo
        }
        else {
            self.subtaskInfo = try decoder.factory.decodeTaskInfo(from: decoder)
        }
    }
}
