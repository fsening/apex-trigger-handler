public abstract class TriggerHandler {
    private abstract void bulkBefore();
    private abstract void beforeInsert(SObject so);
    private abstract void beforeUpdate(SObject oldSo, SObject so);
    private abstract void beforeDelete(SObject so);

    private abstract void bulkAfter();
    private abstract void afterInsert(SObject so);
    private abstract void afterUpdate(SObject oldSo, SObject so);
    private abstract void afterDelete(SObject so);

    private abstract void andFinally();

    public void execute() {
        if (Trigger.isBefore) {
            this.bulkBefore();

            switch on Trigger.operationType {
                when BEFORE_DELETE {
                    for (SObject so : Trigger.old) {
                        this.beforeDelete(so);
                    }
                }
                when BEFORE_INSERT {
                    for (SObject so : Trigger.new) {
                        this.beforeInsert(so);
                    }
                }
                when BEFORE_UPDATE {
                    for (SObject so : Trigger.old) {
                        this.beforeUpdate(so, Trigger.newMap.get(so.Id));
                    }
                }
            }
        } else if (Trigger.isAfter) {
            this.bulkAfter();

            switch on Trigger.operationType {
                when AFTER_DELETE {
                    for (SObject so : Trigger.old) {
                        this.afterDelete(so);
                    }
                }
                when AFTER_INSERT {
                    for (SObject so : Trigger.new) {
                        this.afterInsert(so);
                    }
                }
                when AFTER_UPDATE {
                    for (SObject so : Trigger.old) {
                        this.afterUpdate(so, Trigger.newMap.get(so.Id));
                    }
                }
            }
        }

        this.andFinally();
    }
}
