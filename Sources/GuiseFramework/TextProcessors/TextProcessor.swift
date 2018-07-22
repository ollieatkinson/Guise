import Result

protocol TextProcessor {
  func process(input: String) -> Result<String, APIGeneratorError>
}
