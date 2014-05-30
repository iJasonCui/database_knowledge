create replication definition "JasonTest_RepTest"
with primary at LogicalSRV.JasonTest
with all tables named "RepTest"
(
        "repTestId" int,
        "dateTime" datetime
)
primary key ( "repTestId")
go


