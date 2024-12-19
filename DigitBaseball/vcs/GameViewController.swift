import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var forthLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var enterField: UITextField!
    @IBOutlet weak var attemptLabel: UILabel!
    @IBOutlet weak var resultList: UITableView!
    @IBOutlet weak var resultLabel: UILabel!

    @IBOutlet weak var mostLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    private var targetNumber: [Int] = []
    private var attempts: [(input: String, result: String)] = []

    private var attemptCount: Int = 0
    private var bestAttemptRecord: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // 테이블 뷰 델리게이트 및 데이터 소스 설정
        resultList.delegate = self
        resultList.dataSource = self

        // 4자리 숫자 생성
        generateTargetNumber()

        // 버튼 액션 설정
        enterButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)

        // 시도 회수 초기화 및 최고 기록 초기화
        updateAttemptLabel()
        mostLabel.text = "이곳에 최고 기록이 표시됩니다."
    }

    private func generateTargetNumber() {
        var digits = Array(0...9).shuffled()

        // 첫 번째 자리는 0이 올 수 없도록 설정
        if let firstDigitIndex = digits.firstIndex(where: { $0 != 0 }) {
            targetNumber.append(digits.remove(at: firstDigitIndex))
        }

        targetNumber.append(contentsOf: digits.prefix(3))
        print("Target Number: \(targetNumber)") // 디버깅용

        // 라벨에 숫자 숨김 처리
        firstLabel.text = "?"
        secondLabel.text = "?"
        thirdLabel.text = "?"
        forthLabel.text = "?"
    }

    private func calculateResult(for input: String) -> String {
        guard input.count == 4, input.allSatisfy({ $0.isNumber }) else {
            return "잘못된 입력"
        }

        let inputDigits = input.compactMap { $0.wholeNumberValue }

        var strikes = 0
        var balls = 0

        for (index, digit) in inputDigits.enumerated() {
            if targetNumber[index] == digit {
                strikes += 1
            } else if targetNumber.contains(digit) {
                balls += 1
            }
        }

        return "\(strikes)S \(balls)B"
    }

    @objc private func enterButtonTapped() {
        guard let input = enterField.text, !input.isEmpty else {
            showAlert(message: "입력을 확인하세요")
            return
        }

        if input.count != 4 || !input.allSatisfy({ $0.isNumber }) {
            showAlert(message: "4자리 숫자를 입력하세요")
            return
        }

        if hasDuplicateDigits(input) {
            showAlert(message: "같은 숫자를 두 번 이상 입력할 수 없습니다.")
            return
        }

        if input.first == "0" {
            showAlert(message: "첫 숫자는 0이 될 수 없습니다.")
            return
        }

        // 라벨 업데이트
        updateLabels(for: input)

        let result = calculateResult(for: input)

        if result == "4S 0B" {
            handleSuccess()
            return
        }

        resultLabel.text = result

        // 결과를 리스트에 추가
        attempts.append((input: input, result: result))
        resultList.reloadData()

        // 시도 회수 증가
        attemptCount += 1
        updateAttemptLabel()

        // 텍스트 필드 초기화
        enterField.text = ""
    }

    private func handleSuccess() {
        attemptCount += 1 // 4S를 포함한 횟수를 반영
        if let bestRecord = bestAttemptRecord {
            if attemptCount < bestRecord {
                showAlert(message: "축하합니다! 최고 기록을 경신하였습니다!")
                bestAttemptRecord = attemptCount
                mostLabel.text = "최고 기록: \(attemptCount)회"
            } else {
                showAlert(message: "축하합니다! 정답을 맞추셨습니다!")
            }
        } else {
            showAlert(message: "축하합니다! 정답을 맞추셨습니다!")
            bestAttemptRecord = attemptCount
            mostLabel.text = "최고 기록: \(attemptCount)회"
        }

        // 텍스트 필드 초기화
        enterField.text = ""

        resetGame()
    }

    private func updateLabels(for input: String) {
        let inputDigits = input.map { String($0) }
        firstLabel.text = inputDigits.indices.contains(0) ? inputDigits[0] : "?"
        secondLabel.text = inputDigits.indices.contains(1) ? inputDigits[1] : "?"
        thirdLabel.text = inputDigits.indices.contains(2) ? inputDigits[2] : "?"
        forthLabel.text = inputDigits.indices.contains(3) ? inputDigits[3] : "?"
    }

    private func updateAttemptLabel() {
        attemptLabel.text = "시도 횟수: \(attemptCount)"
    }

    private func hasDuplicateDigits(_ input: String) -> Bool {
        let inputDigits = Array(input)
        return Set(inputDigits).count != inputDigits.count
    }

    private func resetGame() {
        targetNumber.removeAll()
        attempts.removeAll()
        attemptCount = 0
        updateAttemptLabel()
        resultLabel.text = ""
        resultList.reloadData()
        generateTargetNumber()
        firstLabel.text = "?"
        secondLabel.text = "?"
        thirdLabel.text = "?"
        forthLabel.text = "?"
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attempts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let attempt = attempts[indexPath.row]
        cell.textLabel?.text = "입력: \(attempt.input) - 결과: \(attempt.result)"
        return cell
    }
}
