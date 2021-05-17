pragma solidity >=0.4.22 <0.9.0;

contract Hospital {
    address public owner;
    string public name;

    constructor() public {
        // la primerizima pimer vez que se despliega el contrato, el el msg.sender es el owner
        owner = msg.sender;
    }

    // un modifier para que solo la cuenta del owner haga la operacion
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "You are not authorized, you must be the owner"
        );
        _;
    }


    // mapping es como un hash
    // 1031157643 => sabado a las 10(121536498415135) => Diagnositco ('le duele la cabeza','gabriel','dr pepito')

    mapping(uint256 => mapping(uint256 => Diagnostic)) diagnostics;



    //1031157643 => [332213,123123123]
    mapping(uint256 => uint256[]) diagnosticsDates;


    // diagnositco
    struct Diagnostic {
        string description;
        string userName;
        string doctorName;
    }




    //memory cache => barato
    //storage persistente CARO 
    //stack 
    //https://betterprogramming.pub/learn-solidity-variables-part-3-3b02ca71cf06
    function addDiagnostic(
        uint256 _userId,
        string memory _userName,
        string memory _description,
        string memory _diagnosticBy,
        uint256  _diagnosticDate
    ) public onlyOwner {
        diagnostics[_userId][_diagnosticDate] = Diagnostic({
            description: _description,
            userName: _userName,
            doctorName: _diagnosticBy
        });

        diagnosticsDates[_userId].push(_diagnosticDate);
    }




    //1031157643  => [fecha1 , fhea2, 33333....]
    // view =>> casi no cuesta ether 
    // public =>> cualquier persona la puede ejecutar
    function getDiagnosticDates(uint256 _userId)
        public
        view
        returns (uint256[] memory dates )
    {
        //size de diagnosticsDates sobre el userID
        uint256 length = diagnosticsDates[_userId].length;
        
        dates = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            dates[i] = diagnosticsDates[_userId][i];
        }

        return dates;
    
    }
    





    function getDiagnostic(uint256 _userId, uint256 _date)
        public
        view
        returns (
            string memory,
            string memory,
            string memory
        )
    {
        Diagnostic memory diagnosticTemp = diagnostics[_userId][_date];

        return (
            diagnosticTemp.description,
            diagnosticTemp.userName,
            diagnosticTemp.doctorName
        );
    }
}
