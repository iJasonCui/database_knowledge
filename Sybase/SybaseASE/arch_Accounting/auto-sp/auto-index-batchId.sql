use arch_Accounting 
go 
CREATE NONCLUSTERED INDEX idx_batchId
    ON BatchIdLog(batchId)
go 
CREATE NONCLUSTERED INDEX idx_batchId
    ON CCTranStatus(batchId)
go 
CREATE NONCLUSTERED INDEX idx_batchId
    ON CreditCardTransaction(batchId)
go 
CREATE NONCLUSTERED INDEX idx_batchId
    ON PaymentechRequest(batchId)
go 
CREATE NONCLUSTERED INDEX idx_batchId
    ON PaymentechResponse(batchId)
go 
CREATE NONCLUSTERED INDEX idx_batchId
    ON SettlementResponse(batchId)
go 
