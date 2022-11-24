% Define mission parameters and satellite initial conditions
mission.StartDate = datetime(2019, 1, 4, 12, 0, 0);
mission.Duration  = hours(6);

% Specify Keplerian orbital elements for the satellite(s) at the mission.StartDate.
mission.Satellite.SemiMajorAxis  = 6786233.13; % meters
mission.Satellite.Eccentricity   = 0.0010537;
mission.Satellite.Inclination    = 51.7519;    % deg
mission.Satellite.RAAN           = 95.2562;    % deg
mission.Satellite.ArgOfPeriapsis = 93.4872;    % deg
mission.Satellite.TrueAnomaly    = 202.9234;   % deg

% Specify the latitude and longitude of a ground station to use in access analysis below.
mission.GroundStation.Latitude  = 42;  % deg
mission.GroundStation.Longitude = -71; % deg

% Open and configure the orbit propagation model
mission.mdl = "OrbitPropagatorBlockExampleModel";
open_system(mission.mdl);
snapshotModel(mission.mdl);

