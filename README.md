# Bidnamic DevOps/SRE Challenge

## Considerations

## Assumptions

* The app has tests, simulated here via the single test case in `test_app.py`, which can be ran through CI to ensure quality of code making its way to production.
* There are no requirements for security controls, i.e. we're not concerned about role-based access control (RBAC) or tokens for access to the API, it is entirely open to users.
* We're in early stages where we want to ship a product, we may have to sacrifice some efficiencies are this stage to get to market - e.g. simple `Dockerfile`, no major optimisations.