public with sharing class ContractService {
    
    public static Contract create(Contract con) {
        insert con;
        return con;
    }

    public static Contract getById(Id contractId) {
        return ContractSelector.getById(contractId);
    }

    public static Contract updateContract(Contract con) {
        update con;
        return con;
    }

    public static void deleteContract(Id contractId) {
        Contract con = ContractSelector.getById(contractId);
        if (con != null) {
            delete con;
        }
    }
}