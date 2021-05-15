//
//  Perdictor.swift
//  LotteryStatistics
//
//  Created by Tai Le on 15/05/2021.
//  Copyright © 2021 levantAJ. All rights reserved.
//

import CoreML

final class Predictor {
    func predict(
        number: PredictorNumberType
    ) -> PredictorResult? {
        do {
            switch number {
            case .n2(let n1):
                let n2: Double = try predictN2(n1: n1)
                let n3: Double = try predictN3(n1: n1, n2: n2)
                let n4: Double = try predictN4(n1: n1, n2: n2, n3: n3)
                let n5: Double = try predictN5(n1: n1, n2: n2, n3: n3, n4: n4)
                let n6: Double = try predictN6(n1: n1, n2: n2, n3: n3, n4: n4, n5: n5)
                return PredictorResult( n1: n1, n2: n2, n3: n3, n4: n4, n5: n5, n6: n6)
            case .n3(let n1, let n2):
                let n3: Double = try predictN3(n1: n1, n2: n2)
                let n4: Double = try predictN4(n1: n1, n2: n2, n3: n3)
                let n5: Double = try predictN5(n1: n1, n2: n2, n3: n3, n4: n4)
                let n6: Double = try predictN6(n1: n1, n2: n2, n3: n3, n4: n4, n5: n5)
                return PredictorResult( n1: n1, n2: n2, n3: n3, n4: n4, n5: n5, n6: n6)
            case .n4(let n1, let n2, let n3):
                let n4: Double = try predictN4(n1: n1, n2: n2, n3: n3)
                let n5: Double = try predictN5(n1: n1, n2: n2, n3: n3, n4: n4)
                let n6: Double = try predictN6(n1: n1, n2: n2, n3: n3, n4: n4, n5: n5)
                return PredictorResult( n1: n1, n2: n2, n3: n3, n4: n4, n5: n5, n6: n6)
            case .n5(let n1, let n2, let n3, let n4):
                let n5: Double = try predictN5(n1: n1, n2: n2, n3: n3, n4: n4)
                let n6: Double = try predictN6(n1: n1, n2: n2, n3: n3, n4: n4, n5: n5)
                return PredictorResult( n1: n1, n2: n2, n3: n3, n4: n4, n5: n5, n6: n6)
            case .n6(let n1, let n2, let n3, let n4, let n5):
                let n6: Double = try predictN6(n1: n1, n2: n2, n3: n3, n4: n4, n5: n5)
                return PredictorResult( n1: n1, n2: n2, n3: n3, n4: n4, n5: n5, n6: n6)
            }
        } catch {
            print("Cannot predict with error \(error)")
            return nil
        }
    }
}

struct PredictorResult {
    var n1: Double
    var n2: Double
    var n3: Double
    var n4: Double
    var n5: Double
    var n6: Double
}

enum PredictorNumberType: Equatable {
    case n2(n1: Double)
    case n3(n1: Double, n2: Double)
    case n4(n1: Double, n2: Double, n3: Double)
    case n5(n1: Double, n2: Double, n3: Double, n4: Double)
    case n6(n1: Double, n2: Double, n3: Double, n4: Double, n5: Double)
}

// MARK: - Private

extension Predictor {
    private func predictN2(n1: Double?) throws -> Double {
        guard let n1 = n1 else { return 0 }
        let input = N1ToN2Input(n1: n1)
        let model = try N1ToN2(configuration: MLModelConfiguration())
        let output = try model.prediction(input: input)
        print("predict n2 from n1", output.n2)
        return output.n2
    }

    private func predictN3(n1: Double?, n2: Double?) throws -> Double {
        // Predict N3 from N1, N2
        guard let n1 = n1, let n2 = n2 else { return 0 }
        let input = N1N2ToN3Input(n1: n1, n2: n2)
        let model = try N1N2ToN3(configuration: MLModelConfiguration())
        let output = try model.prediction(input: input)
        print("predict n3 from n1, n2", output.n3)
        return output.n3
    }

    private func predictN4(n1: Double?, n2: Double?, n3: Double?) throws -> Double {
        // Predict N3 from N1, N2
        guard let n1 = n1, let n2 = n2, let n3 = n3 else { return 0 }
        // Predict N4 from N1, N2, N3
        let input = N1N2N3ToN4Input(n1: n1, n2: n2, n3: n3)
        let model = try N1N2N3ToN4(configuration: MLModelConfiguration())
        let output = try model.prediction(input: input)
        print("predict n4 from n1, n2, n3", output.n4)
        return output.n4
    }

    private func predictN5(n1: Double?, n2: Double?, n3: Double?, n4: Double?) throws -> Double {
        // Predict N3 from N1, N2
        guard let n1 = n1, let n2 = n2, let n3 = n3, let n4 = n4 else { return 0 }
        // Predict N4 from N1, N2, N3
        let input4 = N1N2N3N4ToN5Input(n1: n1, n2: n2, n3: n3, n4: n4)
        let model = try N1N2N3N4ToN5(configuration: MLModelConfiguration())
        let output = try model.prediction(input: input4)
        print("predict n5 from n1, n2, n3, n4", output.n5)
        return output.n5
    }

    private func predictN6(n1: Double?, n2: Double?, n3: Double?, n4: Double?, n5: Double?) throws -> Double {
        guard let n1 = n1, let n2 = n2, let n3 = n3, let n4 = n4, let n5 = n5 else { return 0 }
        let input = N1N2N3N4N5ToN6Input(n1: n1, n2: n2, n3: n3, n4: n4, n5: n5)
        let model = try N1N2N3N4N5ToN6(configuration: MLModelConfiguration())
        let output = try model.prediction(input: input)
        print("predict n6 from n1, n2, n3, n4, n5", output.n6)
        return output.n6
    }
}
