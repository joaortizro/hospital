//exportamos el contrato
const Hospital = artifacts.require("Hospital");

// libreria para manejar dates
const moment = require("moment");

// libreria para hacer test
const chai = require("chai");
const chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
const expect = chai.expect;

contract("Hospital", (accounts) => {
  //by default acc[0] is owner
  const owner = accounts[0];
  // default behaviour of any contract
  describe("Contract instance", () => {
    it("should retrieve a non-null instance of the contract", () => {
      return Hospital.deployed().then((instance) => {
        hospital = instance;
        expect(hospital).not.to.be.null;
      });
    });
    it("should be registered with owner acc", () => {
      return hospital.owner().then((registeredOwnser) => {
        expect(registeredOwnser).to.eq(owner);
      });
    });
  });

  describe("diagnostic information", () => {
    const uuid = 122333;
    const userName = "Jonathan Alberto Ortiz Rodrigez";
    const diagnostic = "presenta dolor de cabeza";
    const diagnosticBy = "Dr. pepito";
    const diagnosticDate = parseInt(moment().format("x"));

    it("should add a new diagnostic", () => {
      return hospital
        .addDiagnostic(uuid, userName, diagnostic, diagnosticBy, diagnosticDate)
        .then((response) => {
          expect(response.tx).to.match(/0x[a-fA-F0-9]{64}/);
        });
    });

    it("should retreive diagnostic by user id and date", () => {
      return hospital.getDiagnostic(uuid, diagnosticDate).then((response) => {
        const [a, b, c] = Object.values(response);
        expect(a).to.eq(diagnostic);
        expect(b).to.eq(userName);
        expect(c).to.eq(diagnosticBy);
      });
    });

    it("should retrieve dates in which the user attended to be diagnosed", () => {
      return hospital.getDiagnosticDates(uuid).then((response) => {
        expect(diagnosticDate).to.eq(parseInt(response.toString()))
      });
    });
  });
});
