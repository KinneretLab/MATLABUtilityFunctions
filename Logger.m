classdef Logger < handle
    % Logger record events and progress and display them in user friendly format
    % 
    % MATLAB has three ways to show messages to the user:
    % - typing the value out, which yields a long message with lots of
    %   whitespace that also takes a lot of time to calculate
    % - the disp() command, which shows the value in one line, but it can
    %   only show values of things, so any string replacements have to be
    %   done natively. This causes the code to look messy
    % - fprintf, which is really nice with format replacement, but it lacks
    %   color, debugging details like time, and things like progress still
    %   take tons of space.
    %
    % This logger solves all these problems, and offers the following
    % features:
    % - like fprintf, all log messages have the same format features, where
    %   %s will be substituted by a string argument, %d will be substituted
    %   by an integer argument, and %f will be substituted by a float
    %   argument.
    % - All of the log messages automatically contain the class they were
    %   sent from, and the time the message was recorded.
    % - The logger supports several types of log messages, each with their
    %   own unique color: debug, info, progress, warning, and error.
    % - each log type also has a severity level, and a user can configure
    %   what severity level to ignore.
    % - The progress log type is uniqye since sequential uses of the same
    %   action causes the message to update instead of create a brand new
    %   message. In addition, it also features an updating progress bar.
    %
    % Using logs in general is important not only because they give useful
    % information to the user, but they also make the user feel like the
    % program is more efficient. Perception is very important!
    %
    % Only one logger should be used per class and should be a constant,
    % private property. To construct it, all you need is to feed in the
    % class name of the class it is stored in:
    % <code>logger = Logger('MyClass');</code>
    % From there, you can log any message you want using the functions
    % below. There are also a few static functions to set global
    % configurations.

    properties (Constant, Access = private)
        % the size of the progress bar in progress messages (the #. part).
        % This cannot be updated by a user, but you can change this
        % parameter by hand here if you absolutely want to. You shouldn't
        % though.
        bar_size = 40;
    end
    
    properties(Access=private)
        clazz
    end

    methods(Static)
        function done
            Logger.lastLineLength(0);
        end

        function out = level(level)
            % level set the minimum level of severity of messages all loggers will report to the user
            %
            % There can be a whole lot of log messages and they can really
            % blind the user, especially when they are not neccesary. For
            % this we can use the seveirty filter to only see stuff
            % neccesary for the user.
            %
            % By default, level(1) is used, which only ignores debug
            % severity.
            % level(2) ignores info and progress, and level(3) ignores
            % warnings. level(4) ignores everything. level(0) shows all
            % messages, even debug.
            %
            % This method is also capable of querying the level but that's
            % less neccesary.
            persistent level_;
            if nargin
                level_ = level;
            end
            if isempty(level_)
                level_ = 1;
            end
            out = level_;
        end
        function out = logRateSeconds(rate)
            % logRateSeconds set the updating rate of progress logs
            %
            % Since progress logs are used in a loop, they get triggered
            % very often. This can introduce unneccesary delay in the
            % program if done too often, and worry the user too much if it
            % is not often enough. This parameter tells the logger how long
            % since the last progress message it is allowed to send the
            % next. By default this is 0.5s, but you can set it to any
            % number (or fraction) of a second. The argument number is
            % always in seconds.
            %
            % This method is also capable of querying the rate but that's
            % less neccesary.
            persistent rate_;
            if nargin
                rate_ = seconds(rate);
            end
            if isempty(rate_)
                rate_ = seconds(0.5);
            end
            out = rate_;
        end
    end
    methods(Static, Access=private)
        function out = lastLineLength(last_line_length)
            persistent line_length_;
            if nargin
                line_length_ = last_line_length;
            end
            if isempty(line_length_)
                line_length_ = 0;
            end
            out = line_length_;
        end
        function out = lastLog(last_log)
            persistent last_log_;
            if nargin
                last_log_ = last_log;
            end
            if isempty(last_log_)
                last_log_ = datetime('now');
            end
            out = last_log_;
        end
    end
    
    methods
        function obj = Logger(clazz)
            obj.clazz = clazz;
        end
        
        function debug(obj, format, varargin)
            % debug log a debug message
            %
            % Debug messages are the lowest severity messages. They include
            % very fine details on the inner workings of the program that
            % only a developer would understand and use. These messages
            % would usually be ignored unless you are trying to debug a
            % problem.
            %
            % Arguments:
            %   format - Format of the output fields, specified using 
            %       formatting operators. formatSpec also can include 
            %       ordinary text and special characters. If formatSpec 
            %       includes literal text representing escape characters, 
            %       such as \n, then the log translates the escape 
            %       characters. formatSpec can be a character vector 
            %       in single quotes, or a string scalar. For more info
            %       read on the input arguments of fprintf.
            %   varargin - the list of substitutions for use in the format.
            obj.log('[0,0.4,0]', "DEBUG", 0, format, varargin{:});
        end
        
        function info(obj, format, varargin)
            % info log an information message
            %
            % Info messages are the normal progress reports. These messages
            % report normal bahavior the user would be intrested in, like
            % what step is happening, what are the configurations of the
            % program, etc. There should be a few of these, and they should
            % be informative to a non-dev user. These are not ignored by
            % default, but it's not an issue to ignore them either
            %
            % Arguments:
            %   format - Format of the output fields, specified using 
            %       formatting operators. formatSpec also can include 
            %       ordinary text and special characters. If formatSpec 
            %       includes literal text representing escape characters, 
            %       such as \n, then the log translates the escape 
            %       characters. formatSpec can be a character vector 
            %       in single quotes, or a string scalar. For more info
            %       read on the input arguments of fprintf.
            %   varargin - the list of substitutions for use in the format.
            obj.log('[0,0,0]', "INFO", 1, format, varargin{:});
        end
        
        function warn(obj, format, varargin)
            % warn log a warning
            %
            % Warning messages are used when something goes wrong or
            % unexpected in the program, but that doesn't crash it. For
            % example, changes from the normal behavior due to lack of
            % files or parameters. In a more specific example, making a
            % plot with no data to plot would return a warning letting the
            % user know no plot was generated, which is unexpected but
            % doesn't crash the program. These messages should not be
            % ignored, but in very rare cases they would be.
            %
            % Arguments:
            %   format - Format of the output fields, specified using 
            %       formatting operators. formatSpec also can include 
            %       ordinary text and special characters. If formatSpec 
            %       includes literal text representing escape characters, 
            %       such as \n, then the log translates the escape 
            %       characters. formatSpec can be a character vector 
            %       in single quotes, or a string scalar. For more info
            %       read on the input arguments of fprintf.
            %   varargin - the list of substitutions for use in the format.
            obj.log('[1,0.4,0]' , "WARN", 2, format, varargin{:});
        end
        
        function error(obj, format, varargin)
            % warn log an error
            %
            % Error messages have the highest severity of all messages.
            % They are used when something goes critically wrong that
            % distrupts the program, either causing it to crash or stop.
            % For example, calling a function without the required
            % arguments will yield an error and crash. Another example is
            % running a plot with parameters that will definatly crash the
            % plotter. These messages should never be ignored.
            %
            % Arguments:
            %   format - Format of the output fields, specified using 
            %       formatting operators. formatSpec also can include 
            %       ordinary text and special characters. If formatSpec 
            %       includes literal text representing escape characters, 
            %       such as \n, then the log translates the escape 
            %       characters. formatSpec can be a character vector 
            %       in single quotes, or a string scalar. For more info
            %       read on the input arguments of fprintf.
            %   varargin - the list of substitutions for use in the format.
            obj.log('[0.9,0,0]', "ERROR", 3, format, varargin{:});
        end

        function progress(obj, format, current, total, varargin)
            % info log a progress message
            %
            % Progress messages are just like info messages, but they
            % include a progress bar. These messages have the special
            % property that instead of generating a new line every time,
            % they override the previous progress log giving the effect of
            % a dynamic progress bar that doesn't clutter the screen. These
            % are the best form of info logs because they constantly update
            % and make the user feel like progress is being made. These are 
            % not ignored by default, but it's not an issue to ignore them 
            % either.
            %
            % Arguments:
            %   format - Format of the output fields, specified using 
            %       formatting operators. formatSpec also can include 
            %       ordinary text and special characters. If formatSpec 
            %       includes literal text representing escape characters, 
            %       such as \n, then the log translates the escape 
            %       characters. formatSpec can be a character vector 
            %       in single quotes, or a string scalar. For more info
            %       read on the input arguments of fprintf.
            %   current - progress reports have a list of items or tasks
            %       they need to complete. Here you say how many of the
            %       items the programm completed.
            %   total - progress reports have a list of items or tasks
            %       they need to complete. Here you say how many of the
            %       items the programm need to complete in total
            %       (complete + incomplete)
            %   varargin - the list of substitutions for use in the format.
            if current == 1 || current == total || datetime('now') - Logger.lastLog > Logger.logRateSeconds
                if current == 1
                    Logger.lastLineLength(0);
                end
                % generate progress string
                num_done = floor(current / total * obj.bar_size);
                num_left = obj.bar_size - num_done;
                prog_str = sprintf(" [%s%s] (%d/%d)", repmat('#', 1, num_done), repmat('.', 1, num_left), current, total);
                % do the printing
                obj.log('[0,0,0.7]', "PROG", 1, format + prog_str, varargin{:});
            end
        end
        
        function log(obj, color, level_name, level, format, varargin)
            % log log a custom type of log, with its own color and severity
            %
            % If the current log types aren't enough for you, you can use
            % this method to add them. Don't like the colors? Want a
            % super-hyper-fine level? A fatal type? Multiple progress bars?
            % If so, this is the method for you.
            %
            % Arguments:
            %   color - the color to use for the log message, in the format
            %       of a string containing a (1,3) array of numbers ranging
            %       0-1. This is an RGB array.
            %   level_name - the name of the log type to use in the log
            %       report. Calling the level PROG will enable the "line
            %       overriding" feature. You can call it anything you want.
            %   level - the severity lebel of the log type, that is, how
            %       hard it is to ignore. This can be any real number,
            %       including frations and negatives. For reference:
            %       - debug is 0
            %       - info & progress are 1
            %       - warning is 2
            %       - error is 3
            %   format - Format of the output fields, specified using 
            %       formatting operators. formatSpec also can include 
            %       ordinary text and special characters. If formatSpec 
            %       includes literal text representing escape characters, 
            %       such as \n, then the log translates the escape 
            %       characters. formatSpec can be a character vector 
            %       in single quotes, or a string scalar. For more info
            %       read on the input arguments of fprintf.
            %   varargin - the list of substitutions for use in the format.
            if Logger.level <= level
                time_str = datetime('now');
                time_str.Format =  'yyyy-MM-dd HH:mm:ss';
                if level_name == "PROG"
                    fprintf(repmat('\b', 1, Logger.lastLineLength))
                end
                message = sprintf("[%s %s] [%s] " + format + "\n", time_str, obj.clazz, level_name, varargin{:});
                line_length = cprintf(color,message);
                if level_name == "PROG"
                    Logger.lastLineLength(line_length);
                    Logger.lastLog(time_str);
                else
                    Logger.lastLineLength(0);
                end
            end
        end
    end
end

