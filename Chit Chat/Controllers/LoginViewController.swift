import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emailPlaceholder = "Email"
        let emailPlaceholderColor = UIColor.lightGray
                
        let passwordPlaceholder = "Password"
        let passwordPlaceholderColor = UIColor.lightGray
                
        let emailAttributedPlaceholder = NSAttributedString(
            string: emailPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: emailPlaceholderColor]
        )
                
        let passwordAttributedPlaceholder = NSAttributedString(
            string: passwordPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: passwordPlaceholderColor]
        )
                
        // Assign the attributed strings to the placeholder property of the text fields
        emailTextfield.attributedPlaceholder = emailAttributedPlaceholder
        passwordTextfield.attributedPlaceholder = passwordAttributedPlaceholder
    }
    
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text ,let password = passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                }
                else{
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
        
        
    }
    
    
}
