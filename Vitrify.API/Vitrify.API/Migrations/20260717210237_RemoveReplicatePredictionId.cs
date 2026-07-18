using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Vitrify.API.Migrations
{
    /// <inheritdoc />
    public partial class RemoveReplicatePredictionId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ReplicatePredictionId",
                table: "JobItems");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ReplicatePredictionId",
                table: "JobItems",
                type: "text",
                nullable: true);
        }
    }
}
