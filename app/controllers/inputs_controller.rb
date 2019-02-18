require 'json'

class InputsController < ApplicationController
    def run_prediction
        params.require([:lat, :lon, :time, :altitude, :profile])
        profile = params[:profile]

        inputs = {}

        if profile=='optimize'
            params.require([:type, :bal, :setpoint, :tolerance])

            #inputs = params.permit(:lat, :lon, :time, :altitude, :bal, :setpoint, :tolerance).as_json
            inputs = {
                activity: "optimize",
                state0: {
                    lat: params[:lat],
                    lon: params[:lon],
                    bal: params[:bal],
                    t: params[:time],
                    alt: params[:altitude]
                },
                hyperparams: {
                    lr_set: params[:setpoint],
                    lr_tol: params[:tolerance]
                }
            }.to_json
        elsif profile=='simflightplan'
            params.require([:bal, :t0, :dt, :T, :setpoints, :tols])

            setpoints_array = params[:setpoints].split(",").map(&:strip)
            tols_array = params[:tols].split(",").map(&:strip)

            #inputs = params.permit(:lat, :lon, :time, :altitude, :bal, :flight_plan).as_json
            inputs = {
                activity: "simulate",
                state0: {
                    lat: params[:lat],
                    lon: params[:lon],
                    bal: params[:bal],
                    t: params[:time],
                    alt: params[:altitude]
                },
                objfn: {
                    type: params[:type]
                },
                flight_plans: {
                    t0: params[:t0],
                    dt: params[:dt],
                    T: params[:T],
                    setpoints: setpoints_array,
                    tols: tols_array
                }
            }.to_json
        elsif profile=='targetpoint'
            params.require([:bal, :target_lat, :target_lon])

            #inputs = params.permit(:lat, :lon, :time, :altitude, :bal, :target_lat, :target_lon).as_json
            inputs = {
                activity: "targetpoint",
                state0: {
                    lat: params[:lat],
                    lon: params[:lon],
                    bal: params[:bal],
                    t: params[:time],
                    alt: params[:altitude]
                },
                objfn: {
                    type: "MinDistanceToPoint",
                    lat: params[:target_lat],
                    lon: params[:target_lon]
                }
            }.to_json
        elsif profile=='standard'
            params.require([:ascent_rate, :descent_rate, :burst_altitude])

            #inputs = params.permit(:lat, :lon, :time, :altitude, :ascent_rate, :descent_rate, :burst_altitude).as_json
            inputs = {
                activity: "standardprofile",
                state0: {
                    lat: params[:lat],
                    lon: params[:lon],
                    bal: params[:bal],
                    t: params[:time],
                    alt: params[:altitude]
                }
            }.to_json
        end

        puts("inputs is #{inputs}")

        prediction = predict(inputs)

        puts("prediction is #{prediction}")
        
        #render json: { predict(function_name, inputs) }
    end
end
