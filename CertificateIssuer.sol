// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CertificateIssuer {
    address public issuer;

    struct Certificate {
        string studentName;
        string courseName;
        uint256 issueDate;
        bool isValid;
    }

    mapping(address => Certificate) public certificates;

    event CertificateIssued(address indexed student, string course);
    event CertificateRevoked(address indexed student);

    modifier onlyIssuer() {
        require(msg.sender == issuer, "Not authorized");
        _;
    }

    constructor() {
        issuer = msg.sender;
    }

    function issueCertificate(address student, string memory studentName, string memory courseName) public onlyIssuer {
        certificates[student] = Certificate(studentName, courseName, block.timestamp, true);
        emit CertificateIssued(student, courseName);
    }

    function revokeCertificate(address student) public onlyIssuer {
        certificates[student].isValid = false;
        emit CertificateRevoked(student);
    }

    function verifyCertificate(address student) public view returns (string memory, string memory, uint256, bool) {
        Certificate memory cert = certificates[student];
        return (cert.studentName, cert.courseName, cert.issueDate, cert.isValid);
    }
}
