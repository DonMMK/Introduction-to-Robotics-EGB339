
classdef coppeliaRobot < handle
   
    properties
        vrep
        clientID
        handles
        robot
        ip
        port
        nDoF
        motor_control_mode
        robot_name
        tool_goal_dist
    end
    
    methods
        
        function obj = coppeliaRobot(robot_name)
            disp('Creating robot')
            obj.ip = '127.0.0.1';
            obj.port = 19997;
                        
            if robot_name == ""
                obj.robot_name = 'Dobot';
                obj.nDoF = 5;
            elseif strcmp(robot_name,'Dobot')
                obj.nDoF = 5;
                obj.robot_name = robot_name;
            end
                
            obj.connectVrep();
            obj.motor_control_mode = 'position';
            obj.tool_goal_dist = {};

        end
               
        function setJointPositions(obj, q)
            
            obj.tool_goal_dist{end+1} = obj.getTooltoCylinderDistance();
            
            %change motor control mode for each joint
            if ~strcmp(obj.motor_control_mode, 'position')
                obj.motor_control_mode = 'position';
                for i = 1:obj.nDoF
                    obj.vrep.simxSetObjectIntParameter(obj.clientID, obj.handles.joints(i),obj.vrep.sim_jointintparam_ctrl_enabled,1,obj.vrep.simx_opmode_oneshot);
                end
            end
            
            %need to add some error checking here
            if length(q) == obj.nDoF
                for i = 1:obj.nDoF
                    [~]=obj.vrep.simxSetJointTargetPosition(obj.clientID,obj.handles.joints(i),deg2rad(q(i)),obj.vrep.simx_opmode_oneshot );
                end
            else
                error('q not the same size as number of joints')
            end
        end
            
        function setJointVelocities(obj, qdot)
            
            %change motor control mode for each joint
            if ~strcmp(obj.motor_control_mode, 'velocity')
                obj.motor_control_mode = 'velocity';
                for i = 1:obj.nDoF
                    obj.vrep.simxSetObjectIntParameter(obj.clientID, obj.handles.joints(i),obj.vrep.sim_jointintparam_ctrl_enabled,0, obj.vrep.simx_opmode_oneshot);
                end
            end
            
            if length(qdot) == obj.nDoF
                % Apply joint velocity commands to each joint
                for i = 1:length(qdot)
                    obj.vrep.simxSetJointTargetVelocity(obj.clientID,obj.handles.joints(i),qdot(i),obj.vrep.simx_opmode_oneshot );
                    
                end
            else
                error('qdot not the same size as number of joints')
            end
                 
        end
        
        function setSuctionCup(obj,signal)
           
            if signal
                obj.vrep.simxSetIntegerSignal(obj.clientID, 'Dobot_suctionCup', true, obj.vrep.simx_opmode_oneshot);
            else
                obj.vrep.simxSetIntegerSignal(obj.clientID, 'Dobot_suctionCup', false, obj.vrep.simx_opmode_oneshot);
            end
            
        end

        function image = getImage(obj)
            
            [~,~,image]= obj.vrep.simxGetVisionSensorImage2(obj.clientID,obj.handles.cameraHandle,0,obj.vrep.simx_opmode_buffer);
            
        end

        %get joint positions in degrees
        function [q] = getJointPositions(obj)
            
            for i = 1:obj.nDoF
                [~,obj.robot.q(i)]=obj.vrep.simxGetJointPosition(obj.clientID,obj.handles.joints(i),obj.vrep.simx_opmode_buffer );
            end
            
            q = rad2deg(obj.robot.q);
              
        end
        
        % get joint velocities in deg/s
        function [qdot] = getJointVelocities(obj)
            
            for i = 1:obj.nDoF
                [~,obj.robot.qdot(i)]=obj.vrep.simxGetObjectFloatParameter(obj.clientID,obj.handles.joints(i),2012,obj.vrep.simx_opmode_buffer );
            end

            qdot = rad2deg(obj.robot.qdot);
                
        end
        
        function [q, qdot] = getJointPosVel(obj)
            
            for i = 1:obj.nDoF
                [~,obj.robot.q(i)]=obj.vrep.simxGetJointPosition(obj.clientID,obj.handles.joints(i),obj.vrep.simx_opmode_buffer );
                [~,obj.robot.qdot(i)]=obj.vrep.simxGetObjectFloatParameter(obj.clientID,obj.handles.joints(i),2012,obj.vrep.simx_opmode_buffer );
            end
            
            q = rad2deg(obj.robot.q);
            qdot = rad2deg(obj.robot.qdot);
                
        end
        
        function setTargetGoalPositions(obj,init_xy,dest_xy)
            for i = 1:length(init_xy)
               obj.vrep.simxSetObjectPosition(obj.clientID,obj.handles.goalHandle(i),-1,[init_xy(i,1:2) 0.7],obj.vrep.simx_opmode_oneshot );
               obj.vrep.simxSetObjectPosition(obj.clientID,obj.handles.targetHandle(i),-1,[dest_xy(i,1:2) 0.7],obj.vrep.simx_opmode_oneshot );
            end
        end
        
        %These will not be available to you during the exam
        function setCylinderPosition(obj,xy)
          
            for i = 1:length(xy)
               obj.vrep.simxSetObjectPosition(obj.clientID,obj.handles.cylinderHandle(i),-1,[xy(i,1:2) 0.7226],obj.vrep.simx_opmode_oneshot );
            end
            
        end
        
        %These will not be available to you during the exam
        function [xy] = getCylinderPositions(obj)
          
            for i = 1:3
               [~,xyz]=obj.vrep.simxGetObjectPosition(obj.clientID,obj.handles.cylinderHandle(i),-1,obj.vrep.simx_opmode_streaming);  
                xy(i,:) = xyz(1:2);
            end
            
        end

        %These will not be available to you during the exam
        function showExamSheet(obj,i)
          
            obj.vrep.simxSetObjectPosition(obj.clientID,obj.handles.examSheetHandle(1),-1,[0.1945 0.2905 0.650199],obj.vrep.simx_opmode_oneshot );  
            obj.vrep.simxSetObjectPosition(obj.clientID,obj.handles.examSheetHandle(2),-1,[0.1945 0.2905 0.65199],obj.vrep.simx_opmode_oneshot );
            obj.vrep.simxSetObjectPosition(obj.clientID,obj.handles.examSheetHandle(i),-1,[0.1945 0.2905 0.70199],obj.vrep.simx_opmode_oneshot );

        end
        
        %These will not be available to you during the exam
        function [tool_xy_dist] = getTooltoCylinderDistance(obj)
            for i = 1:6
               [~] = obj.vrep.simxCallScriptFunction(obj.clientID,'Dobot', obj.vrep.sim_scripttype_childscript, 'handleDistance',[],[],[],[],obj.vrep.simx_opmode_blocking);
                
               [~,dist]=obj.vrep.simxReadDistance(obj.clientID,obj.handles.distanceHandle(i),obj.vrep.simx_opmode_blocking);  
                tool_xy_dist(i,:) = dist; 
            end
        end
        
        %These will not be available to you during the exam
        function clearToolGoalDistances(obj)
            obj.tool_goal_dist = {};
        end
        
        function connectVrep(obj)
            
            disp('Connecting to Simulator');
            obj.vrep = remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
            %obj.vrep.simxFinish(-1); % just in case, close all opened connections
            
            obj.clientID = obj.vrep.simxStart(obj.ip,obj.port,true,true,5000,1);
            
            if (obj.clientID>-1)
                disp('Connected to remote API server');
                
                % ensure sim is stopped if reconnecting
                obj.vrep.simxStopSimulation(obj.clientID, obj.vrep.simx_opmode_oneshot);

                % Now try to retrieve data in a blocking fashion (i.e. a service call):
                [res,objs]=obj.vrep.simxGetObjects(obj.clientID,obj.vrep.sim_handle_all,obj.vrep.simx_opmode_blocking);
                if (res==obj.vrep.simx_return_ok)
                    fprintf('Successfully connected to API server \n');
                else
                    fprintf('Remote API function call returned with error code: %d\n',res);
                end

                % Now send some data to V-REP in a non-blocking fashion:
                obj.vrep.simxAddStatusbarMessage(obj.clientID,'Matlab Connected to EGB339 Prac Simulator!', obj.vrep.simx_opmode_oneshot);
                pause(3);
                
                for i = 1:obj.nDoF
                    if strcmp(obj.robot_name,'Dobot')
                        joint_name = convertStringsToChars("Dobot_motor"+i);
                    elseif strcmp(obj.robot_name,'UR3')
                        joint_name = convertStringsToChars("UR3_joint"+i);
                    elseif strcmp(obj.robot_name,'NiryoOne')
                        joint_name = convertStringsToChars("NiryoOneJoint"+i);
                    end
                    
                    [~, obj.handles.joints(i)] = obj.vrep.simxGetObjectHandle(obj.clientID,joint_name,obj.vrep.simx_opmode_blocking);
                    [~] = obj.vrep.simxGetJointPosition(obj.clientID, obj.handles.joints(i),obj.vrep.simx_opmode_streaming);
                    [~] = obj.vrep.simxGetObjectFloatParameter(obj.clientID,obj.handles.joints(i),2012,obj.vrep.simx_opmode_streaming );
                    
                end
                
                [~, obj.handles.cameraHandle] = obj.vrep.simxGetObjectHandle(obj.clientID,'Vision_sensor',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.robotHandle] = obj.vrep.simxGetObjectHandle(obj.clientID,'Dobot',obj.vrep.simx_opmode_blocking);

                [~, obj.handles.cylinderHandle(1)] = obj.vrep.simxGetObjectHandle(obj.clientID,'Cylinder0',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.cylinderHandle(2)] = obj.vrep.simxGetObjectHandle(obj.clientID,'Cylinder1',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.cylinderHandle(3)] = obj.vrep.simxGetObjectHandle(obj.clientID,'Cylinder2',obj.vrep.simx_opmode_blocking);

                [~, obj.handles.targetHandle(1)] = obj.vrep.simxGetObjectHandle(obj.clientID,'Target_0',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.targetHandle(2)] = obj.vrep.simxGetObjectHandle(obj.clientID,'Target_1',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.targetHandle(3)] = obj.vrep.simxGetObjectHandle(obj.clientID,'Target_2',obj.vrep.simx_opmode_blocking);
                
                [~, obj.handles.goalHandle(1)] = obj.vrep.simxGetObjectHandle(obj.clientID,'Goal_0',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.goalHandle(2)] = obj.vrep.simxGetObjectHandle(obj.clientID,'Goal_1',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.goalHandle(3)] = obj.vrep.simxGetObjectHandle(obj.clientID,'Goal_2',obj.vrep.simx_opmode_blocking);
                
                [~, obj.handles.distanceHandle(1)] = obj.vrep.simxGetDistanceHandle(obj.clientID,'Target_0',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.distanceHandle(2)] = obj.vrep.simxGetDistanceHandle(obj.clientID,'Target_1',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.distanceHandle(3)] = obj.vrep.simxGetDistanceHandle(obj.clientID,'Target_2',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.distanceHandle(4)] = obj.vrep.simxGetDistanceHandle(obj.clientID,'Goal_0',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.distanceHandle(5)] = obj.vrep.simxGetDistanceHandle(obj.clientID,'Goal_1',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.distanceHandle(6)] = obj.vrep.simxGetDistanceHandle(obj.clientID,'Goal_2',obj.vrep.simx_opmode_blocking);
                                
                [~, obj.handles.examSheetHandle(1)] = obj.vrep.simxGetObjectHandle(obj.clientID,'ExamSheet_1',obj.vrep.simx_opmode_blocking);
                [~, obj.handles.examSheetHandle(2)] = obj.vrep.simxGetObjectHandle(obj.clientID,'ExamSheet_2',obj.vrep.simx_opmode_blocking);

                %this is used to initialise the streaming of data from each
                %object
                [~]=obj.vrep.simxGetVisionSensorImage2(obj.clientID,obj.handles.cameraHandle,0,obj.vrep.simx_opmode_streaming);
                [~]=obj.vrep.simxGetObjectPosition(obj.clientID,obj.handles.cylinderHandle(1),-1,obj.vrep.simx_opmode_streaming);
                [~]=obj.vrep.simxGetObjectPosition(obj.clientID,obj.handles.cylinderHandle(2),-1,obj.vrep.simx_opmode_streaming);
                [~]=obj.vrep.simxGetObjectPosition(obj.clientID,obj.handles.cylinderHandle(3),-1,obj.vrep.simx_opmode_streaming);
                [~]=obj.vrep.simxGetObjectPosition(obj.clientID,obj.handles.examSheetHandle(1),-1,obj.vrep.simx_opmode_streaming);
                [~]=obj.vrep.simxGetObjectPosition(obj.clientID,obj.handles.examSheetHandle(2),-1,obj.vrep.simx_opmode_streaming);

            else
                disp('Failed to connect to remote API server');
                obj.delete()
            end
        end
        
        function startSim(obj,sync)
            
            %use sync flag to operate in syncronous mode 
            %requires manual call to stepSim() function to make sim take
            %one time step
            if sync
                obj.vrep.simxSynchronous(obj.clientID, true);
            end
            
            ret = obj.vrep.simxStartSimulation(obj.clientID, obj.vrep.simx_opmode_oneshot);
            if ret == obj.vrep.simx_return_initialize_error_flag 
                disp('Error with starting simulation, please retry your connection')
            end
        end

        function stepSim(obj)
            obj.vrep.simxSynchronousTrigger(obj.clientID); %% Trigger next simulation step (Blocking function call)
            obj.vrep.simxGetPingTime(obj.clientID); %% After this call, the first simulation step is finished (Blocking function call)
        end

        function stopSim(obj)% Now close the connection to V-REP:
            ret = obj.vrep.simxStopSimulation(obj.clientID, obj.vrep.simx_opmode_oneshot);
            if ret == obj.vrep.simx_return_initialize_error_flag 
                disp('Error with starting simulation, please retry your connection')
            end
        end
        
        function delete(obj)
            disp('Closing connection to sim');
            obj.vrep.simxStopSimulation(obj.clientID, obj.vrep.simx_opmode_oneshot);
            obj.vrep.simxFinish(obj.clientID);
            obj.vrep.delete(); % call the destructor! 
        end
    end

end