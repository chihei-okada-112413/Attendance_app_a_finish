module AttendancesHelper

    TIME_00 = "00"
    TIME_15 = 15
    TIME_30 = 30
    TIME_45 = 45

    YEAR = "2021"
    MONTH = "6"
     
    def attendance_state(attendance)
        # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
        if Date.current == attendance.worked_on
            return '出勤' if attendance.started_at.nil?
            return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
        end
        # どれにも当てはまらなかった場合はfalseを返します。
        false
    end
    def time_fix(t)
        if t <= 59 && t >= 45
          TIME_45
        elsif t < 45 && t >= 30
          TIME_30
        elsif t < 30 && t >= 15
          TIME_15
        elsif t < 15 && t >= 0
          TIME_00
        end
    end  

    def user_no(u)
      u + 1
    end
    
    # 出勤時間と退勤時間を受け取り、在社時間を計算して返す。
    def working_time(start, finish)
      #debugger
        format("%.2f", (((finish - start) / 60) / 60.0))
    end

    def working_time_start_chage(start)
      #debugger
      start.hour.to_i * 60 + time_fix(start.min.to_i).to_i
    end

    def working_time_finish_chage(finish)
      #debugger
      finish.hour.to_i * 60 + time_fix(finish.min.to_i).to_i
    end

    def working_time_chage(start, finish)
      #debugger
      format("%.2f", ((finish - start) / 60.0))
    end

    def working_time_chage_next(start, finish)
      #debugger
      format("%.2f", ((((finish.hour.to_i + 24) * 60 + time_fix(finish.min.to_i).to_i) - start) / 60.0))
    end

    def over_time(over, finish)
      #debugger
        format("%.2f", ((over - finish) / 60.0))
    end

    def zangyo_time(overtime)
        overtime.hour.to_i * 60 + time_fix(overtime.min.to_i).to_i
    end

    def zangyo_time_next(overtime)
      (overtime.hour.to_i + 24) * 60 + time_fix(overtime.min.to_i).to_i
    end

    def syuryo_time(syuryotime)
        syuryotime.hour.to_i * 60 + time_fix(syuryotime.min.to_i).to_i
    end
end

