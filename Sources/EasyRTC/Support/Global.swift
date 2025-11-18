// merge a ClosedRange
func merge<T>(range range1: ClosedRange<T>, with range2: ClosedRange<T>) -> ClosedRange<T> where T: Comparable {
    min(range1.lowerBound, range2.lowerBound) ... max(range1.upperBound, range2.upperBound)
}
