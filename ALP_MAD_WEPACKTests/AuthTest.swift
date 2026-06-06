//
//  AuthTest.swift
//  ALP_MAD_WEPACKTests
//
//  Created by Anastasia on 04/06/26.
//

import XCTest
@testable import ALP_MAD_WEPACK

final class AuthTest: XCTestCase {
    
    var viewModel: AuthViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AuthViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoginValidation_EmptyEmail_ShouldBeInvalid() {
        viewModel.loginEmail = ""
        viewModel.loginPassword = "password123"
        
        XCTAssertFalse(viewModel.isLoginValid, "Login harusnya tidak valid jika email kosong")
    }
    
    func testLoginValidation_ShortPassword_ShouldBeInvalid() {
        viewModel.loginEmail = "caca@student.uc.ac.id"
        viewModel.loginPassword = "12345"
        
        XCTAssertFalse(viewModel.isLoginValid, "Login harusnya tidak valid jika password kurang dari 6 karakter")
    }
    
    func testLoginValidation_ValidCredentials_ShouldBeValid() {
        viewModel.loginEmail = "caca@student.uc.ac.id"
        viewModel.loginPassword = "password123"
        
        XCTAssertTrue(viewModel.isLoginValid, "Login harusnya valid jika email dan password terisi dengan benar")
    }
    
    func testRegisterValidation_EmptyName_ShouldBeInvalid() {
        viewModel.registerName = ""
        viewModel.registerUsername = "caca123"
        viewModel.registerEmail = "caca@student.uc.ac.id"
        viewModel.registerPassword = "password123"
        viewModel.registerConfirmPassword = "password123"
        
        XCTAssertFalse(viewModel.isRegisterValid, "Register harusnya tidak valid jika nama kosong")
    }
    
    func testRegisterValidation_ShortPassword_ShouldBeInvalid() {
        viewModel.registerName = "Caca"
        viewModel.registerUsername = "caca123"
        viewModel.registerEmail = "caca@student.uc.ac.id"
        viewModel.registerPassword = "pass123"
        viewModel.registerConfirmPassword = "pass123"
        
        XCTAssertFalse(viewModel.isRegisterValid, "Register harusnya tidak valid jika password kurang dari 8 karakter")
    }
    
    func testRegisterValidation_PasswordMismatch_ShouldBeInvalid() {
        viewModel.registerName = "Caca"
        viewModel.registerUsername = "caca123"
        viewModel.registerEmail = "caca@student.uc.ac.id"
        viewModel.registerPassword = "password123"
        viewModel.registerConfirmPassword = "password321"
        
        XCTAssertFalse(viewModel.isRegisterValid, "Register harusnya tidak valid jika password dan konfirmasi password tidak cocok")
    }
    
    func testRegisterValidation_ValidFields_ShouldBeValid() {
        viewModel.registerName = "Caca"
        viewModel.registerUsername = "caca123"
        viewModel.registerEmail = "caca@student.uc.ac.id"
        viewModel.registerPassword = "password123"
        viewModel.registerConfirmPassword = "password123"
        
        XCTAssertTrue(viewModel.isRegisterValid, "Register harusnya valid jika semua field terisi dengan benar")
    }
    
    func testLogout_ShouldClearAllFields() {
        // Isi field dengan data dummy
        viewModel.loginEmail = "caca@student.uc.ac.id"
        viewModel.loginPassword = "password123"
        viewModel.registerName = "Caca"
        viewModel.registerUsername = "caca123"
        
        viewModel.logout()
        
        XCTAssertEqual(viewModel.loginEmail, "", "loginEmail harusnya kosong setelah logout")
        XCTAssertEqual(viewModel.loginPassword, "", "loginPassword harusnya kosong setelah logout")
        XCTAssertEqual(viewModel.registerName, "", "registerName harusnya kosong setelah logout")
        XCTAssertEqual(viewModel.registerUsername, "", "registerUsername harusnya kosong setelah logout")
    }
    
    func testLoginValidation_WhitespaceEmail_ShouldBeInvalid() {
        viewModel.loginEmail = "   "
        viewModel.loginPassword = "password123"
        
        XCTAssertFalse(viewModel.isLoginValid, "Login tidak valid jika email hanya berisi spasi")
    }
    
    func testRegisterValidation_WhitespaceUsername_ShouldBeInvalid() {
        viewModel.registerName = "Caca"
        viewModel.registerUsername = "   "
        viewModel.registerEmail = "caca@student.uc.ac.id"
        viewModel.registerPassword = "password123"
        viewModel.registerConfirmPassword = "password123"
        
        XCTAssertFalse(viewModel.isRegisterValid, "Register tidak valid jika username hanya berisi spasi")
    }
}
