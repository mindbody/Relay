//
//  DynamicTypes.swift
//  Relay
//
//  Created by John Hammerlund on 6/18/19.
//

import UIKit

protocol ConstructableDynamicType: class {
    init()
}

final class DynamicTypes {
    final class TypeA: ConstructableDynamicType {}; final class TypeB: ConstructableDynamicType {}
    final class TypeC: ConstructableDynamicType {}; final class TypeD: ConstructableDynamicType {}
    final class TypeE: ConstructableDynamicType {}; final class TypeF: ConstructableDynamicType {}
    final class TypeG: ConstructableDynamicType {}; final class TypeH: ConstructableDynamicType {}
    final class TypeI: ConstructableDynamicType {}; final class TypeJ: ConstructableDynamicType {}
    final class TypeK: ConstructableDynamicType {}; final class TypeL: ConstructableDynamicType {}
    final class TypeM: ConstructableDynamicType {}; final class TypeN: ConstructableDynamicType {}
    final class TypeO: ConstructableDynamicType {}; final class TypeP: ConstructableDynamicType {}
    final class TypeQ: ConstructableDynamicType {}; final class TypeR: ConstructableDynamicType {}
    final class TypeS: ConstructableDynamicType {}; final class TypeT: ConstructableDynamicType {}
    final class TypeU: ConstructableDynamicType {}; final class TypeV: ConstructableDynamicType {}
    final class TypeW: ConstructableDynamicType {}; final class TypeX: ConstructableDynamicType {}
    final class TypeY: ConstructableDynamicType {}; final class TypeZ: ConstructableDynamicType {}
    final class Type1: ConstructableDynamicType {}; final class Type2: ConstructableDynamicType {}
    final class Type3: ConstructableDynamicType {}; final class Type4: ConstructableDynamicType {}
    final class Type5: ConstructableDynamicType {}; final class Type6: ConstructableDynamicType {}
    final class Type7: ConstructableDynamicType {}; final class Type8: ConstructableDynamicType {}
    final class Type9: ConstructableDynamicType {}; final class Type0: ConstructableDynamicType {}

    static var allTypes: [ConstructableDynamicType.Type] = [
        TypeA.self, TypeB.self, TypeC.self, TypeD.self,
        TypeE.self, TypeF.self, TypeG.self, TypeH.self,
        TypeI.self, TypeJ.self, TypeK.self, TypeL.self,
        TypeM.self, TypeN.self, TypeO.self, TypeP.self,
        TypeQ.self, TypeR.self, TypeS.self, TypeT.self,
        TypeU.self, TypeV.self, TypeW.self, TypeX.self,
        TypeY.self, TypeZ.self, Type1.self, Type2.self,
        Type3.self, Type4.self, Type5.self, Type6.self,
        Type7.self, Type8.self, Type9.self, Type0.self
    ]
}
