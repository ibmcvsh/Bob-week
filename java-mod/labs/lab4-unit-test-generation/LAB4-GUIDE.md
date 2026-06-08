# IBM Bob AI Copilot - Unit Test Generation Lab Guide
## Simple Pharmacy Dashboard - Comprehensive Test Coverage

---

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Unit Test Generation with Bob's Advanced Mode](#unit-test-generation-with-bobs-advanced-mode)
4. [Step-by-Step Exercises](#step-by-step-exercises)
5. [Troubleshooting](#troubleshooting)
6. [Conclusion](#conclusion)

---

# Introduction

### What is Unit Test Generation?

Unit Test Generation is the process of creating automated tests that verify individual components of an application work correctly in isolation. This typically involves:
- **Test Case Design**: Identifying what to test and how to test it
- **Mock Creation**: Isolating units from their dependencies
- **Assertion Writing**: Verifying expected behavior
- **Edge Case Coverage**: Testing boundary conditions and error scenarios
- **Test Organization**: Structuring tests for maintainability

## About This Lab

In this lab, you'll use IBM Bob's **Advanced mode** to generate comprehensive unit tests for a pharmacy management application. The application currently has **no tests**, and you'll create a complete test suite covering:

### Components to Test:
1. **REST API Resources** (PrescriptionResource, OrderResource, MedicineResource, DashboardResource)
   - HTTP endpoint behavior
   - Request/response handling
   - Error scenarios
   - Status code validation

2. **Repository Classes** (PrescriptionRepository, OrderRepository, MedicineRepository)
   - CRUD operations
   - Search and filter functionality
   - Data integrity
   - Concurrent access scenarios

3. **Model Classes** (Prescription, Order, Medicine)
   - Constructor validation
   - Getter/setter behavior
   - Business logic methods

### Testing Technologies:
- **JUnit 5**: Modern testing framework
- **Mockito**: Mocking framework for dependencies
- **AssertJ**: Fluent assertions for better readability
- **Maven Surefire**: Test execution and reporting

## Learning Objectives

By completing this lab, you will learn how to use Bob's Advanced mode to:
- Generate comprehensive unit tests for Java applications
- Create effective mocks and test doubles
- Write tests for REST API endpoints
- Test repository and data access layers
- Achieve high code coverage
- Implement testing best practices
- Structure and organize test suites

---

# Prerequisites

## Required Software

Before starting this lab, ensure you have:

- **IBM Bob IDE** - Latest version installed and logged in with **Advanced mode** access
- **Java 21** - JDK 21 LTS
- **Maven 3.6+** - Build automation tool

**Don't have these installed?** See the [automated installation scripts](../../GETTING_STARTED.md#-quick-start-5-minutes) in GETTING_STARTED.md to install all dependencies quickly.

**Switching to Java 21 (if needed):**

If you have multiple Java versions installed and need to switch to Java 21:

```bash
# Using SDKMAN (if installed via automated script)
sdk use java 21-tem

# Verify
java -version
```

### 3. Apache Maven
Maven is required to build and run tests.

**Installation Instructions:**
- Download from: https://maven.apache.org/download.cgi
- Or use SDKMAN:
  ```bash
  sdk install maven
  ```

**Verify Maven Installation:**
```bash
mvn -version
```

You should see Maven version information along with the Java version that Maven is using.

**Important Note on Java Versions:**
When you run `mvn -version`, it shows the Java version that Maven will use to build your project. This may differ from your system's default Java version (shown by `java -version`). Maven uses the Java version specified by the `JAVA_HOME` environment variable or the Java installation that SDKMAN! has configured.

## Important: Understanding Bob's Advanced Mode

This lab requires Bob's **Advanced mode**, which provides:
- **Test Generation**: Intelligent creation of comprehensive test suites
- **Multi-file Operations**: Simultaneous reading and test creation for multiple classes
- **Testing Patterns**: Knowledge of JUnit 5, Mockito, and testing best practices
- **Coverage Analysis**: Understanding what needs to be tested

**To access Advanced mode:**
1. Open Bob's chat interface
2. Click on the current mode indicator at the bottom
3. Select "🚀 Advanced" from the mode dropdown
4. Confirm you want to switch to Advanced mode

---

# Unit Test Generation with Bob's Advanced Mode

## Overview of Bob's Advanced Mode for Test Generation

IBM Bob's Advanced mode provides powerful capabilities for creating comprehensive test suites:

### Key Features for Testing:
1. **Intelligent Test Design**: Bob analyzes the codebase to understand what needs testing, identifies critical paths and edge cases, determines appropriate test strategies, and creates comprehensive test plans.

2. **Automated Test Creation**: Bob generates JUnit 5 test classes with proper structure, creates Mockito mocks for dependencies, writes meaningful test methods with clear names, and implements proper setup and teardown methods.

3. **Best Practices Implementation**: Bob follows testing conventions and patterns, uses appropriate assertion libraries (AssertJ), implements proper test isolation, and creates maintainable and readable tests.

4. **Coverage Optimization**: Bob ensures all public methods are tested, covers edge cases and error scenarios, tests both success and failure paths, and validates boundary conditions.

---

# Step-by-Step Exercises

## Exercise 1: Project Setup and Test Infrastructure

1. **Open Bob Chat Interface**
   - If the Bob Chat window is not already open, click the Bob icon in your IDE's sidebar

2. **Switch to Bob's Advanced Mode**
   - Click on the current mode name at the bottom of the chat
   - Select "🚀 Advanced" from the mode dropdown
   - Confirm the mode switch if prompted

3. **Set Up Testing Dependencies**
   
   In Bob's chat, type:
   ```
   I need to add unit testing capabilities to this Java project. Please:
   1. Update pom.xml to include JUnit 5, Mockito, and AssertJ dependencies
   2. Configure the Maven Surefire plugin for test execution
   3. Create the test directory structure (src/test/java)
   
   Use the latest stable versions of testing frameworks.
   ```

4. **Verify Setup**
   - Review Bob's changes to pom.xml
   - Ensure test directory structure is created
   - Run `mvn clean test` to verify the setup (tests will pass as none exist yet)

## Exercise 2: Generate Repository Tests

1. **Test All Repository Classes**
   
   Ask Bob:
   ```
   Generate comprehensive unit tests for all three repository classes: PrescriptionRepository.java, MedicineRepository.java, and OrderRepository.java.
   
   For PrescriptionRepository, include tests for:
   - getInstance() singleton pattern
   - generateId() ID generation
   - addPrescription() and findById()
   - findAll() returning all prescriptions
   - findByPatientId() filtering
   - findByStatus() filtering
   - updatePrescription() modification
   - deletePrescription() removal
   - Edge cases (null values, empty results, etc.)
   
   For MedicineRepository, include tests for:
   - Singleton pattern
   - CRUD operations (add, find, update, delete)
   - searchByName() with various inputs
   - updateStock() including edge cases (insufficient stock, negative quantities)
   - Sample data initialization
   
   For OrderRepository, include tests for:
   - All CRUD operations
   - findByPatientId(), findByStatus(), findByPrescriptionId()
   - ID generation
   - Edge cases and boundary conditions
   
   Use JUnit 5 and follow best practices. Create the test files in src/test/java/com/pharmacy/repository/
   ```

2. **Run Repository Tests**  (if not run automatically by Bob)
   ```bash
   mvn test
   ```

## Exercise 3: Generate REST API Resource Tests

1. **Test All REST API Resource Classes**
   
   Ask Bob:
   ```
   Generate comprehensive unit tests for all four REST API resource classes: PrescriptionResource.java, OrderResource.java, MedicineResource.java, and DashboardResource.java.
   
   For PrescriptionResource, include tests for:
   - getAllPrescriptions() - retrieval successful
   - getPrescriptionById() - found and not found scenarios
   - createPrescription() - success, invalid medicine ID, missing data, validation errors
   - validatePrescription() - success, not found, invalid status transitions
   
   For OrderResource, include tests for:
   - getAllOrders() and getOrderById()
   - createOrderFromPrescription() - success, prescription not found, not validated, insufficient stock
   - processPayment() - success, order not found, invalid status, payment method validation
   - collectOrder() - success, order not found, not paid
   
   For MedicineResource, include tests for:
   - getAllMedicines()
   - getMedicineById() - found and not found
   - searchMedicines() - with name, empty name, no results
   
   For DashboardResource, include tests for:
   - getDashboardData() returns correct structure
   - Proper aggregation of pending prescriptions and orders
   - Total counts are accurate
   
   Use Mockito to mock all repository dependencies (PrescriptionRepository, MedicineRepository, OrderRepository).
   Test HTTP response codes and response bodies.
   Use JUnit 5 and AssertJ for assertions.
   Create the test files in src/test/java/com/pharmacy/api/
   ```

2. **Run API Tests** (if not run automatically by Bob)
   ```bash
   mvn test
   ```

## Exercise 4: Generate Model Tests

1. **Test Model Classes**
   
   Ask Bob:
   ```
   Generate unit tests for the model classes (Prescription, Order, Medicine). Include:
   - Constructor tests with valid data
   - Getter and setter tests
   - Edge cases (null values, boundary conditions)
   - Any business logic methods
   - toString(), equals(), and hashCode() if implemented
   
   These should be simple tests focusing on data integrity.
   ```

2. **Run Model Tests** (if not run automatically by Bob)
   ```bash
   mvn test
   ```

## Exercise 5: Test Coverage Analysis and Improvement

1. **Add Code Coverage Plugin**
   
   Ask Bob:
   ```
   Add JaCoCo (Java Code Coverage) plugin to pom.xml to measure test coverage.
   Configure it to generate coverage reports.
   ```

2. **Run Coverage Report** (if not run automatically by Bob)
   ```bash
   mvn clean test jacoco:report
   ```

3. **Analyze Coverage**
   
   Ask Bob:
   ```
   Review the JaCoCo coverage report at target/site/jacoco/index.html.
   Identify any gaps in test coverage and suggest additional tests to improve coverage.
   ```

4. **Generate Missing Tests**
   - Based on Bob's analysis, ask for additional tests to cover gaps
   - Focus on achieving >80% code coverage

## Exercise 6: Integration and Edge Case Testing

1. **Add Integration-Style Tests**
   
   Ask Bob:
   ```
   Create integration-style tests that test multiple components together:
   - Test the full flow: create prescription → validate → create order → process payment → collect
   - Test error propagation between layers
   - Test concurrent access scenarios for repositories
   
   These tests should use real repository instances (not mocks) but still be unit tests.
   ```

2. **Add Edge Case Tests**
   
   Ask Bob:
   ```
   Create additional edge case tests for:
   - Concurrent modifications to the same prescription/order
   - Very large quantities or amounts
   - Special characters in patient names or medicine names
   - Date boundary conditions (expired prescriptions, future dates)
   - Empty or null collections
   ```

## Exercise 7: Test Organization and Documentation

1. **Organize Test Suite**
   
   Ask Bob:
   ```
   Review the test suite and suggest improvements for:
   - Test class organization and naming
   - Test method naming conventions
   - Common setup code that could be extracted
   - Test data builders or fixtures
   - Documentation and comments
   ```

2. **Create Test Documentation**
   
   Ask Bob:
   ```
   Create a TESTING.md document that includes:
   - Overview of the test suite structure
   - How to run tests (all tests, specific tests, with coverage)
   - Testing conventions and patterns used
   - How to add new tests
   - Coverage goals and current status
   ```

3. **Run Full Test Suite**
   ```bash
   mvn clean test
   ```

### Expected Outcome
- Complete test suite with 50+ test methods
- >80% code coverage across all layers
- All tests passing
- Well-organized and maintainable test code
- Comprehensive documentation
- Fast test execution (<30 seconds)

---

# Troubleshooting

## Issue 1: API Request Failed

**Symptom:**
```
{"apiProtocol":"openai"}
```

**Solution:**
Select "Retry" in the Bob chat window

## Issue 2: Test Compilation Errors

**Symptom:**
Tests fail to compile with missing imports or dependencies

**Solution:**
1. Verify all testing dependencies are in pom.xml
2. Run `mvn clean install` to download dependencies
3. Ask Bob to review and fix import statements
4. Ensure Java version is 21

## Issue 3: Mock Injection Failures

**Symptom:**
```
NullPointerException in tests when accessing mocked objects
```

**Solution:**
1. Ensure `@ExtendWith(MockitoExtension.class)` is on test class
2. Verify `@Mock` and `@InjectMocks` annotations are correct
3. Check that mocks are initialized in `@BeforeEach` if needed
4. Ask Bob to review mock setup

## Issue 4: Tests Fail Due to Singleton State

**Symptom:**
Tests pass individually but fail when run together

**Solution:**
1. Repository singletons maintain state between tests
2. Add reset methods to repositories or use reflection to reset instances
3. Ask Bob to implement proper test isolation
4. Consider using `@TestInstance(Lifecycle.PER_CLASS)` with proper cleanup

## Issue 5: Coverage Report Not Generated

**Symptom:**
JaCoCo report directory doesn't exist

**Solution:**
1. Ensure JaCoCo plugin is properly configured in pom.xml
2. Run `mvn clean test jacoco:report` (not just `mvn test`)
3. Check for errors in Maven output
4. Verify target/site/jacoco directory is created

---

## Getting Help

### During the Lab
1. **Ask Bob** - Bob can help explain testing concepts and fix test issues
2. **Ask Your Instructor** - Don't hesitate to raise your hand
3. **Collaborate** - Discuss testing approaches with classmates

### Bob-Specific Tips
- Be specific about what you want to test
- Provide context about the class being tested
- Ask Bob to explain testing patterns if unclear
- Request examples of similar tests
- Use Bob to review and improve existing tests

---

# Conclusion

Congratulations! You've completed the Unit Test Generation lab using Bob's Advanced mode. You should now be able to:

Use Bob's Advanced mode for comprehensive test creation including:  
   ✅ Setting up testing infrastructure and dependencies  
   ✅ Generating unit tests for repositories and data access layers  
   ✅ Creating tests for REST API endpoints with mocks  
   ✅ Testing model classes and business logic  
   ✅ Analyzing and improving code coverage  
   ✅ Organizing and documenting test suites  

## Key Takeaways

1. **Test Early, Test Often** - Automated tests catch bugs before production
2. **Comprehensive Coverage** - Test success paths, error paths, and edge cases
3. **Proper Isolation** - Use mocks to test units in isolation
4. **Readable Tests** - Clear test names and assertions make maintenance easier
5. **Fast Execution** - Unit tests should run quickly to encourage frequent execution
6. **Bob's Testing Expertise** - AI can generate comprehensive test suites efficiently

## Test Suite Achievements

### Coverage Metrics:
- ✅ **Repository Layer** - 90%+ coverage with comprehensive CRUD tests
- ✅ **API Layer** - 85%+ coverage with endpoint and error scenario tests
- ✅ **Model Layer** - 95%+ coverage with data integrity tests

### Test Categories:
- ✅ **Happy Path Tests** - Verify normal operation
- ✅ **Error Handling Tests** - Verify proper error responses
- ✅ **Edge Case Tests** - Verify boundary conditions
- ✅ **Integration Tests** - Verify component interactions

## Next Steps (Optional)

> **Note:** The following activities are optional and can be explored if you have additional time or want to deepen your understanding of the concepts covered in this lab.

Consider exploring the following testing tasks using Bob:

1. **Performance Testing**
   
   Ask Bob:
   ```
   Create performance tests that measure:
   - Response time for API endpoints under load
   - Repository operation performance with large datasets
   - Memory usage during concurrent operations
   
   Use JMH (Java Microbenchmark Harness) for accurate measurements.
   ```

2. **Contract Testing**
   
   Ask Bob:
   ```
   Implement API contract tests using REST Assured to verify:
   - Request/response schemas
   - HTTP status codes
   - Content-Type headers
   - JSON structure validation
   ```

3. **Mutation Testing**
   
   Ask Bob:
   ```
   Add PIT (Mutation Testing) to the project to verify test quality.
   Configure it in pom.xml and analyze mutation coverage reports.
   Improve tests based on surviving mutants.
   ```

4. **Test Data Builders**
   
   Ask Bob:
   ```
   Create test data builder classes for:
   - Prescription objects
   - Order objects
   - Medicine objects
   
   Use the Builder pattern to make test data creation more readable and maintainable.
   ```

5. **Parameterized Tests**
   
   Ask Bob:
   ```
   Convert repetitive tests to parameterized tests using JUnit 5's @ParameterizedTest.
   Focus on tests that verify similar behavior with different inputs.
   ```

6. **Test Containers (Advanced)**
   
   Ask Bob:
   ```
   If we add a database in the future, set up Testcontainers for:
   - Running tests against a real database in Docker
   - Ensuring tests are isolated and repeatable
   - Testing database-specific behavior
   ```

---

**Thank you for completing this lab!** You've successfully used IBM Bob to generate a comprehensive unit test suite for a Java application. This experience demonstrates how Bob can accelerate test creation while ensuring high quality, maintainability, and coverage. Remember: good tests are the foundation of reliable software!
