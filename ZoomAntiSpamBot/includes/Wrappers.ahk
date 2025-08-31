; Utility wrapper functions for compatibility
ToLower(str) {
    StringLower, out, str
    return out
}

ToUpper(str) {
    StringUpper, out, str
    return out
}

TrimStr(str) {
    return Trim(str)
}

Split(str, delim="|") {
    arr := []
    Loop, Parse, str, %delim%
        arr.Push(A_LoopField)
    return arr
}

InStrCompat(haystack, needle) {
    return InStr(haystack, needle)
}
