/*
    Copyright 2017 Zheyong Fan and GPUMD development team
    This file is part of GPUMD.
    GPUMD is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    GPUMD is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with GPUMD.  If not, see <http://www.gnu.org/licenses/>.
*/

#pragma once
#include "property.cuh"
#include "utilities/gpu_vector.cuh"
#include <vector>
class Group;
class Atom;

class MSD : public Property
{
public:
  bool compute_ = false;
  int sample_interval_ = 1;
  int num_correlation_steps_ = 100;
  int grouping_method_ = -1;
  int group_id_ = -1;
  bool msd_over_all_groups_ = false;

  virtual void preprocess(
    const int number_of_steps,
    const double time_step,
    Integrate& integrate,
    std::vector<Group>& group,
    Atom& atom,
    Box& box,
    Force& force);

  virtual void process(
      const int number_of_steps,
      int step,
      const int fixed_group,
      const int move_group,
      const double global_time,
      const double temperature,
      Integrate& integrate,
      Box& box,
      std::vector<Group>& group,
      GPU_Vector<double>& thermo,
      Atom& atom,
      Force& force);

  virtual void postprocess(
    Atom& atom,
    Box& box,
    Integrate& integrate,
    const int number_of_steps,
    const double time_step,
    const double temperature);

  virtual void write(const char* filename);

  MSD(const char** param, const int num_param, const std::vector<Group>& groups, Atom& atom);
  void parse(const char** param, const int num_param, const std::vector<Group>& groups);

private:
  int num_atoms_;
  int num_groups_;
  std::vector<int> num_atoms_per_group_;
  std::vector<int> group_per_atom_cpu_;
  int num_time_origins_;
  int save_output_every_ = -1;
  double dt_in_natural_units_;
  double dt_in_ps_;
  GPU_Vector<double> x_, y_, z_;
  GPU_Vector<double> msdx_, msdy_, msdz_;
  GPU_Vector<double> msdx_out_, msdy_out_, msdz_out_;  // holds output for writing
  GPU_Vector<int> group_per_atom_gpu_;
};
