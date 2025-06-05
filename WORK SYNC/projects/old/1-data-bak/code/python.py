def isfloat(num):
    try:
        float(num)
        return True
    except ValueError:
        return False

class Case:
    
    def __init__(self, name):
        self.name = name

    def set_court(self, court):
        self.court = court

    def set_judge(self, judge):
        self.judge = judge

    def set_can(self, can):
        self.can = can

    def set_status(self, status):
        self.status = status
    
    def set_liamt(self, liamt):
        self.liamt = liamt
        self.liamt_print = "${:,.2f}".format(self.liamt) if isfloat(liamt) else liamt

    def set_licarr(self, licarr):
        self.licarr = licarr

    def set_umamt(self, umamt):
        self.umamt = umamt
        self.umamt_print = "${:,.2f}".format(self.umamt) if isfloat(umamt) else umamt

    def set_umcarr(self, umcarr):
        self.umcarr = umcarr

    def set_meds(self, meds):
        self.meds = meds
        self.meds_print = "${:,.2f}".format(self.meds) if isfloat(meds) else meds

    def set_other(self, other):
        self.other = other
        self.other_print = "${:,.2f}".format(self.other) if isfloat(other) else other 

    def set_demand(self, demand):
        self.demand = demand
        self.demand_print = "${:,.2f}".format(self.demand) if isfloat(demand) else demand

    def set_offer(self, offer):
        self.offer = offer
        self.offer_print = "${:,.2f}".format(self.offer) if isfloat(offer) else offer

    def __repr__(self):
        return 'ID:    %s\nCourt: %s\nJudge: %s\nCAN:   %s\nStatus:  %s\n------- \nLI: %12s | %s\nUM: %12s | %s\n------- \nMeds:   %12s\nOther: %13s\n-------\nDemand: %12s\nOffer:  %12s' % (self.name, self.court, self.judge, self.can, self.status, self.liamt_print, self.licarr, self.umamt_print, self.umcarr, self.meds_print, self.other_print, self.demand_print, self.offer_print)
    
if __name__ == '__main__':
    AdamsShawn = Case('AdamsShawn')
    AdamsShawn.set_court('Hall State')
    AdamsShawn.set_judge('John Breakfield')
    AdamsShawn.set_can('2021SV163D')
    AdamsShawn.set_status('pretrial')
    AdamsShawn.set_liamt(500000.0)
    AdamsShawn.set_licarr('AutoOwners')
    AdamsShawn.set_umamt( 500000.0)
    AdamsShawn.set_umcarr('Progressive')
    AdamsShawn.set_meds(37687.68)
    AdamsShawn.set_other('')
    AdamsShawn.set_demand(375000.0)
    AdamsShawn.set_offer(9500.0)
    print(AdamsShawn)

