

svc = KTCUtils::Service.new("test_service")

svc.endpoint = "testing_api"
svc.type = "api"
svc.lb_algo = "wrr"
svc.add_member "testbox", "127.0.0.1", "80"
svc.save
