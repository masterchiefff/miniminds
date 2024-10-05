// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ELearningPlatform {
    struct User {
        address userAddress;
        string name;
        bool isRegistered;
        uint256[] enrolledCourses;
        uint256 totalEarnings;
        string role;
        string email;
    }

    struct Course {
        uint256 courseId;
        string title;
        string description;
        address instructor;
        uint256 price; 
        bool isActive;
    }

    struct Certificate {
        uint256 courseId;
        address studentAddress;
        string issuedDate; 
    }

    mapping(address => User) public users;
    mapping(uint256 => Course) public courses;
    mapping(address => Certificate[]) public certificates;

    uint256 public courseCount = 0;
    uint256 public platformFeePercentage = 5; 
    address public owner;

    event UserRegistered(address indexed userAddress, string name);
    event CourseCreated(uint256 indexed courseId, string title, address indexed instructor);
    event CourseEnrolled(address indexed userAddress, uint256 indexed courseId);
    event EarningsDistributed(address indexed instructor, uint256 amount);
    event CertificateIssued(address indexed studentAddress, uint256 indexed courseId, string issuedDate);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    }

    modifier onlyRegistered() {
        require(users[msg.sender].isRegistered, "User not registered.");
        _;
    }

    constructor() {
        owner = msg.sender; 
    }

    function registerUser(string memory _name, string memory _role, string memory _email) public {
        require(!users[msg.sender].isRegistered, "User already registered.");
        
        users[msg.sender] = User({
            userAddress: msg.sender,
            name: _name,
            email: _email,
            role: _role,
            isRegistered: true,
            enrolledCourses: new uint256[](0),
            totalEarnings: 0
        });

        emit UserRegistered(msg.sender, _name);
    }

    function createCourse(string memory _title, string memory _description, uint256 _price) public {
        require(_price > 0, "Course price must be greater than zero.");

        courseCount++;
        
        courses[courseCount] = Course({
            courseId: courseCount,
            title: _title,
            description: _description,
            instructor: msg.sender,
            price: _price,
            isActive: true
        });

        emit CourseCreated(courseCount, _title, msg.sender);
    }

    
function enrollInCourse(uint256 _courseId) public payable onlyRegistered {
        require(courses[_courseId].isActive, "Course not active.");
        require(msg.value == courses[_courseId].price, "Incorrect ETH amount sent.");

        users[msg.sender].enrolledCourses.push(_courseId);
        
        uint256 platformFee = (msg.value * platformFeePercentage) / 100;
        uint256 instructorEarnings = msg.value - platformFee;

        payable(courses[_courseId].instructor).transfer(instructorEarnings);
        
        users[courses[_courseId].instructor].totalEarnings += instructorEarnings;

        emit CourseEnrolled(msg.sender, _courseId);
        emit EarningsDistributed(courses[_courseId].instructor, instructorEarnings);
    }

    function issueCertificate(address _studentAddress, uint256 _courseId, string memory _issuedDate) public {
        require(courses[_courseId].instructor == msg.sender, "Only instructor can issue certificates.");
        
        certificates[_studentAddress].push(Certificate({
            courseId: _courseId,
            studentAddress: _studentAddress,
            issuedDate: _issuedDate
        }));

        emit CertificateIssued(_studentAddress, _courseId, _issuedDate);
    }

    function setPlatformFeePercentage(uint256 _newPercentage) public onlyOwner {
        platformFeePercentage = _newPercentage; 
    }
}